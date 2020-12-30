﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("Дерево") И Параметры.Дерево Тогда 
		Запрос = Новый Запрос("ВЫБРАТЬ
		|	Статьи.Ссылка КАК Ссылка,
		|	ВЫБОР
		|		КОГДА Статьи.Ссылка В (&СписокПарам)
		|			ТОГДА 1
		|		ИНАЧЕ 0
		|	КОНЕЦ КАК Пометка
		|ИЗ
		|	Справочник.Статьи КАК Статьи
		|ГДЕ
		|	НЕ Статьи.Ссылка В (&СписокИсключение)
		|
		|УПОРЯДОЧИТЬ ПО
		|	Статьи.Код
		|ИТОГИ ПО
		|	Ссылка ИЕРАРХИЯ");
		
		Если Параметры.свойство("ВыборТолькоГрупп") Тогда 
			Запрос.Текст = СтрЗаменить(Запрос.Текст, "НЕ Статьи.Ссылка В (&СписокИсключение)",
			"НЕ Статьи.Ссылка В (&СписокИсключение)
			|	И Статьи.ЭтоГруппа
			|	И Статьи.родитель = значение(справочник.Статьи.)");
		КонецЕсли;
		
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "Справочник.Статьи", Параметры.ИмяМетаданных);
		
		Запрос.УстановитьПараметр("СписокИсключение", ?(Параметры.Свойство("СписокИсключение"), Параметры.СписокИсключение, Неопределено));
		Запрос.УстановитьПараметр("СписокПарам", Параметры.Список);
		
		Рез = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией);
		
		Пока Рез.Следующий() Цикл
			Если ЗначениеЗаполнено(Рез.Ссылка) Тогда 
				НоваяСтрока = СписокДерево.ПолучитьЭлементы().Добавить();
				
				ЗаполнитьЗначенияСвойств(НоваяСтрока, Рез);
			КонецЕсли;
			
			Если Рез.ТипЗаписи() = ТипЗаписиЗапроса.ИтогПоИерархии Тогда 
				Рез2 = Рез.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией, Рез.Группировка());
			Иначе
				Рез2 = Рез.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией);
			КонецЕсли;
			
			Пока Рез2.Следующий() Цикл
				Если НоваяСтрока <> Неопределено И Рез2.Ссылка = НоваяСтрока.Ссылка Тогда 
					Продолжить;
				КонецЕсли;
				
				Если НоваяСтрока = Неопределено Тогда 
					НоваяСтрока2 = СписокДерево.ПолучитьЭлементы().Добавить();
				Иначе
					НоваяСтрока2 = НоваяСтрока.ПолучитьЭлементы().Добавить();
				КонецЕсли;
				
				ЗаполнитьЗначенияСвойств(НоваяСтрока2, Рез2);
				
				Если Рез2.ТипЗаписи() = ТипЗаписиЗапроса.ИтогПоИерархии Тогда 
					Рез2 = Рез2.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией, Рез2.Группировка());
				Иначе
					Рез3 = Рез2.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией);
				КонецЕсли;
				
				Пока Рез3.Следующий() Цикл
					Если Рез3.Ссылка = НоваяСтрока2.Ссылка Тогда 
						Продолжить;
					КонецЕсли;
					
					НоваяСтрока3 = НоваяСтрока2.ПолучитьЭлементы().Добавить();
					
					ЗаполнитьЗначенияСвойств(НоваяСтрока3, Рез3);
				КонецЦикла;
			КонецЦикла;
		КонецЦикла;
		
		Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаДерево;
		
		Элементы.СписокДерево.ПодчиненныеЭлементы.СписокДеревоПометка.ТриСостояния = Истина;
	Иначе
		Запрос = Новый Запрос("ВЫБРАТЬ
		|	Метки.Ссылка,
		|	ВЫБОР
		|		КОГДА Метки.Ссылка В (&СписокПарам)
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ Ложь
		|	КОНЕЦ КАК Пометка
		|ИЗ
		|	Справочник.Метки КАК Метки
		|ГДЕ
		|	НЕ Метки.Ссылка В (&СписокИсключение)
		|
		|УПОРЯДОЧИТЬ ПО
		|	Метки.Код");
		
		Если Параметры.Свойство("Тип") Тогда 
			Запрос.Текст = СтрЗаменить(Запрос.Текст, "Метки", Строка(Параметры.Тип));
		Иначе
			Запрос.Текст = СтрЗаменить(Запрос.Текст, "Справочник.Метки", Параметры.ИмяМетаданных);
		КонецЕсли;
		
		Если Найти(Параметры.ИмяМетаданных, "Перечисление") > 0 Тогда 
			Запрос.Текст = СтрЗаменить(Запрос.Текст, "Код", "Порядок");
		КонецЕсли;
		
		Запрос.УстановитьПараметр("СписокИсключение", ?(Параметры.Свойство("СписокИсключение"), Параметры.СписокИсключение, Неопределено));
		Запрос.УстановитьПараметр("СписокПарам", Параметры.Список);
		Список.Загрузить(Запрос.Выполнить().Выгрузить());
		
		Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаТаблица;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Если Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаДерево Тогда
		ТекЭлем = СписокДерево.ПолучитьЭлементы();
		
		Для Каждого Стр Из ТекЭлем Цикл
			Стр.Пометка = УстановкаФлажковНачальная(Стр, Стр.Пометка);
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура СписокДеревоПометкаПриИзменении(Элемент)
	Если Элементы.СписокДерево.ТекущиеДанные.пометка = 2 Тогда 
		Элементы.СписокДерево.ТекущиеДанные.пометка = 0;
	КонецЕсли;
		
	УстановкаФлажков(Элементы.СписокДерево.ТекущиеДанные, Элементы.СписокДерево.ТекущиеДанные.Пометка); 
	
	ТекущаяСтрока = Элементы.СписокДерево.ТекущиеДанные;
	
	Пока ТекущаяСтрока.ПолучитьРодителя() <> Неопределено Цикл
		ТекущаяСтрока.ПолучитьРодителя().Пометка = ?(УстановленоДляВсех(ТекущаяСтрока), ТекущаяСтрока.Пометка, 2);
		ТекущаяСтрока = ТекущаяСтрока.ПолучитьРодителя();
	КонецЦикла;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Готово(Команда)
	Рез = ГотовоНаСервере();
	
	Закрыть(Рез);
КонецПроцедуры

&НаКлиенте
Процедура ВыделитьВсе(Команда)
	Если Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаДерево Тогда 
		Для Каждого Строка Из СписокДерево.ПолучитьЭлементы() Цикл
			Строка.Пометка = Истина;
			УстановкаФлажков(Строка, Истина);
		КонецЦикла;
	Иначе
		Для Каждого Строка Из Список Цикл
			Строка.Пометка = Истина;
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СнятьВыделениеВсе(Команда)
	Если Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаДерево Тогда 
		Для Каждого Стр из СписокДерево.ПолучитьЭлементы() Цикл
			Стр.Пометка = Ложь;
			УстановкаФлажков(Стр, Ложь);
		КонецЦикла;
	Иначе
		Для Каждого Стр Из Список Цикл
			Стр.Пометка = Ложь;
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ГотовоНаСервере()
	Если Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаДерево Тогда 
		Дерево = РеквизитФормыВЗначение("СписокДерево", Тип("ДеревоЗначений"));
		
		Поиск = Дерево.Строки.НайтиСтроки(Новый Структура("Пометка", 1), Истина);
		
		СписокРезультат = Новый СписокЗначений;
		
		Для Каждого Строка Из Поиск Цикл
			СписокРезультат.Добавить(Строка.Ссылка);
		КонецЦикла;
	Иначе
		СписокРезультат = Новый СписокЗначений;
		СписокРезультат.ЗагрузитьЗначения(Список.Выгрузить(Новый Структура("Пометка", Истина), "Ссылка").ВыгрузитьКолонку("Ссылка"));
	КонецЕсли;
	
	Возврат СписокРезультат;
КонецФункции

&НаКлиенте
Процедура УстановкаФлажков(ТекСтр, Значение)
	ТекЭлементы = ТекСтр.ПолучитьЭлементы();
	Для Каждого Стр Из ТекЭлементы Цикл
		Стр.Пометка = Значение;
		
		УстановкаФлажков(Стр, Значение);
	КонецЦикла;	
КонецПроцедуры

&НаКлиенте
Функция УстановленоДляВсех(Строка)
	Для Каждого Стр Из Строка.ПолучитьРодителя().ПолучитьЭлементы() Цикл
		Если Стр.Пометка <> Строка.Пометка Тогда
			Возврат Ложь; 
		КонецЕсли;
	КонецЦикла;
	
	Возврат Истина;
КонецФункции

&НаКлиенте
Функция УстановкаФлажковНачальная(ТекСтр, Значение)
	ТекЭлементы = ТекСтр.получитьЭлементы();
	
	Есть1 = Ложь;
	Есть2 = Ложь;
	Есть0 = Ложь;	
	
	Для Каждого Стр из ТекЭлементы Цикл
		Стр.Пометка = УстановкаФлажковНачальная(Стр, Стр.Пометка);
		
		Если Не Есть1 И Стр.Пометка = 1 Тогда 
			Есть1 = Истина;
		КонецЕсли;
		
		Если Не Есть2 И Стр.Пометка = 2 Тогда 
			Есть2 = Истина;
		КонецЕсли;
		
		Если Не Есть0 И Стр.Пометка = 0 Тогда 
			Есть0 = Истина;
		КонецЕсли;
	КонецЦикла;	
	
	Если Не Есть0 И Не Есть1 И Не Есть2 Тогда 
		Возврат Значение;
	ИначеЕсли Есть0 И (Есть1 Или Есть2) Тогда 
		Возврат 2
	ИначеЕсли Есть0 Тогда 
		Возврат 0;
	Иначе
		Возврат 1;
	КонецЕсли;
КонецФункции

#КонецОбласти