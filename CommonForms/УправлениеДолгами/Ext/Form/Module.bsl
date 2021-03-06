﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	ЗаполнитьОстатки();
	
	#Если Не МобильноеПриложениеСервер Тогда
		Элементы.ОстаткиПредставление.Ширина = 0;
		Элементы.ОстаткиСумма.Ширина = 0;
	#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	РазвернутьДерево();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "ОбновитьОстатки" Тогда 
		ЗаполнитьОстатки();
		
		РазвернутьДерево();
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ОстаткиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	Если Элементы.Остатки.ТекущиеДанные.СтрокаИтог = 1 Тогда 
		Возврат;
	КонецЕсли;
	
	Парам = Новый Структура("ОтборПоФизЛицу, ОтборПоВалюте", Элементы.Остатки.ТекущиеДанные.ФизЛицо,
	Элементы.Остатки.ТекущиеДанные.Валюта);
	
	Если Элементы.Остатки.ТекущиеДанные.СтрокаИтог = 0 Тогда 
		Парам.Вставить("ОтборПоМетке", Элементы.Остатки.ТекущиеДанные.Метка);
	КонецЕсли;
	
	ОткрытьФорму("Документ.Операция.ФормаСписка", Парам, ЭтаФорма);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СписатьДолг(Команда)
	Парам = Новый Структура("Физлицо, Сумма, Валюта, ТипОперации, ТипДолга");
	ЗаполнитьЗначенияСвойств(Парам, Элементы.Остатки.ТекущиеДанные);
	
	Парам.ТипОперации = ПредопределенноеЗначение("Перечисление.ТипыОпераций.Долги");
	Парам.ТипДолга = ПредопределенноеЗначение("Перечисление.ТипыДолгов.Списание");
	
	ОткрытьФорму("Документ.Операция.ФормаОбъекта", Новый Структура("ЗначенияЗаполнения", Парам));
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьОстатки()
	Запрос = Новый Запрос("ВЫБРАТЬ
	|	ДолгиОстатки.СуммаОстаток КАК Сумма,
	|	ДолгиОстатки.ФизЛицо КАК ФизЛицо,
	|	ВЫБОР
	|		КОГДА ДолгиОстатки.СуммаОстаток < 0
	|			ТОГДА ""Должен я""
	|		ИНАЧЕ ""Должны мне""
	|	КОНЕЦ КАК ТипДолга,
	|	ДолгиОстатки.Валюта КАК Валюта,
	|	ДолгиОстатки.Валюта.КраткоеНаименование,
	|	ДолгиОстатки.Метка КАК Метка
	|ИЗ
	|	РегистрНакопления.Долги.Остатки(, ) КАК ДолгиОстатки
	|
	|УПОРЯДОЧИТЬ ПО
	|	Валюта,
	|	ФизЛицо,
	|	ДолгиОстатки.Метка.Код
	|ИТОГИ
	|	СУММА(Сумма)
	|ПО
	|	Валюта,
	|	ТипДолга,
	|	ФизЛицо");
	Рез = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Остатки.ПолучитьЭлементы().Очистить();
	
	Пока Рез.Следующий() Цикл
		НоваяСтрокаВал = Остатки.ПолучитьЭлементы().Добавить();
		НоваяСтрокаВал.Сумма = Рез.Сумма;
		НоваяСтрокаВал.Представление = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Итого %1'"), Рез.ВалютаКраткоеНаименование);
		НоваяСтрокаВал.СтрокаИтог = 1;
		
		РезТип = Рез.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		
		Пока РезТип.Следующий() Цикл
			НоваяСтрокаТип = НоваяСтрокаВал.ПолучитьЭлементы().Добавить();
			НоваяСтрокаТип.Сумма = РезТип.Сумма;
			НоваяСтрокаТип.ФизЛицо = РезТип.ФизЛицо;
			НоваяСтрокаТип.Представление = РезТип.ТипДолга;
			НоваяСтрокаТип.СтрокаИтог = 1;
			
			РезФЛ = РезТип.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
			
			Пока РезФЛ.Следующий() Цикл
				НоваяСтрокаФЛ = НоваяСтрокаТип.ПолучитьЭлементы().Добавить();
				НоваяСтрокаФЛ.Сумма = РезФЛ.Сумма;
				НоваяСтрокаФЛ.ФизЛицо = РезФЛ.ФизЛицо;
				НоваяСтрокаФЛ.Валюта = РезФЛ.Валюта;
				НоваяСтрокаФЛ.Представление = РезФЛ.ФизЛицо;
				НоваяСтрокаФЛ.СтрокаИтог = 2;
				
				РезМетка = РезФЛ.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
				
				Пока РезМетка.Следующий() Цикл
					НоваяСтрокаМетка = НоваяСтрокаФЛ.ПолучитьЭлементы().Добавить();
					НоваяСтрокаМетка.Сумма = РезМетка.Сумма;
					НоваяСтрокаМетка.ФизЛицо = РезМетка.Физлицо;
					НоваяСтрокаМетка.Валюта = РезМетка.Валюта;
					НоваяСтрокаМетка.Метка = РезМетка.Метка;
					НоваяСтрокаМетка.Представление = РезМетка.Метка;
				КонецЦикла;
			КонецЦикла;
		КонецЦикла;
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	НовЭлем = УсловноеОформление.Элементы.Добавить();
	ПолеЭлемента = НовЭлем.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Остатки.Имя);
	ОтборЭлемента = НовЭлем.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Остатки.СтрокаИтог");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = 1;
	НовЭлем.Оформление.УстановитьЗначениеПараметра("Шрифт", Новый Шрифт(, , Истина));
	НовЭлем.Использование = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура РазвернутьДерево()
	
	Если Остатки.ПолучитьЭлементы().Количество() > 0 Тогда 
		ИД = Остатки.ПолучитьЭлементы()[0].ПолучитьИдентификатор();
		Элементы.Остатки.Развернуть(ИД, Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти