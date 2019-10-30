﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)	
	
	ОтчетыСКД.ПриСозданииНаСервере(ЭтотОбъект);
	
	ПодготовитьФормуНаСервере();
	
	#Если МобильноеПриложениеСервер Тогда 
		Элементы.ГруппаСтраницы.ОтображениеСтраниц = ОтображениеСтраницФормы.Пролистывание;
	#Иначе
		Элементы.ГруппаСтраницы.ОтображениеСтраниц = ОтображениеСтраницФормы.ЗакладкиСверху;
	#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ЗавершениеРаботы Тогда 
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	ПриЗакрытииНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура Группа2ПриСменеСтраницы(Элемент, ТекущаяСтраница)
	
	ОбновитьТекущуюСтраницу();
	
КонецПроцедуры

&НаКлиенте
Процедура ТабДокОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	
	КомпоновкаДанныхКлиент.ОбработкаРасшифровки(ЭтотОбъект, Элемент, Расшифровка, АдресДанныхРасшифровкиОтчет, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура НастроитьОформлениеДиаграммы()
	ШрифтПодписей = Новый Шрифт(ШрифтыСтиля.МелкийШрифтТекста);
	
	ДиаграммаОстатки.ШрифтПодписей = ШрифтПодписей;
	
	ДиаграммаОстатки.ОбластьПостроения.Шрифт = ШрифтПодписей;
	ДиаграммаОстатки.ОбластьПостроения.Верх = 0;
	ДиаграммаОстатки.ОбластьПостроения.Лево = 0;
	ДиаграммаОстатки.ОбластьПостроения.Низ = 1;
	ДиаграммаОстатки.ОбластьПостроения.Право = 1;
	ДиаграммаОстатки.ОбластьПостроения.ЛинииШкалы = новый Линия(ТипЛинииДиаграммы.Пунктир, 1);
	ДиаграммаОстатки.ОбластьПостроения.ФорматШкалыЗначений  = "ЧРГ=.";
	
	ДиаграммаОстатки.ОбластьПостроения.ЦветШкалы = WebЦвета.Черный;
КонецПроцедуры

&НаСервере
Процедура ПодготовитьФормуНаСервере()
	
	КлючОбъекта = Метаданные.Обработки.Отчеты.Имя + ЭтаФорма.ИмяФормы;
	
	Если Параметры.Свойство("ОбщиеРасходы") Тогда 
		ОбщиеРасходы = Истина;
		
		КлючОбъекта = КлючОбъекта + "ОбщиеРасходы";
	КонецЕсли;
	
	ОбщиеНастройкиВызовСервера.ЗагрузитьОсновнуюНастройку(ЭтотОбъект);
	
	НастроитьОформлениеДиаграммы();
	
	ОбновитьТекущуюСтраницу();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьТекущуюСтраницу() Экспорт 
	
	Если Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаДиаграммы Тогда
		Если Не ДиаграммаСформирована Тогда 
			ОбновитьДиаграммуСервер();
		КонецЕсли;
	Иначе
		Если Не ОтчетСформирован Тогда 
			ОбновитьСерверСКД();
		КонецЕсли;
	КонецЕсли;
	
	ЭтотОбъект.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Остатки по кошелькам, %1'"), ВалютаОтчета);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьСерверСКД()
	
	ТабДок.Очистить();
	
	СхемаКомпоновкиДанных = ПолучитьИзВременногоХранилища(ЭтотОбъект.АдресСКД);
	
	СтруктураПараметров = Новый Структура("Периодичность");
	
	ОтчетыСКД.ПолучитьПараметрыНастроекСКД(СхемаКомпоновкиДанных, ЭтотОбъект.АдресНастроекСКД, , , СтруктураПараметров);
	
	Если СтруктураПараметров.Периодичность <> Перечисления.Периодичность.Регистратор Тогда 
		ТекстЗапросаОригинальный = СхемаКомпоновкиДанных.НаборыДанных.НаборДанных1.Запрос;
		СхемаКомпоновкиДанных.НаборыДанных.НаборДанных1.Запрос = СтрЗаменить(ТекстЗапросаОригинальный, "МЕСЯЦ", ВРег(СтруктураПараметров.Периодичность));
	КонецЕсли;
	
	ОтчетыСКД.ПолучитьДанныеОтчета(СхемаКомпоновкиДанных, ТабДок, Неопределено, УникальныйИдентификатор, Неопределено,
	АдресДанныхРасшифровкиОтчет, Ложь, ЭтотОбъект.АдресНастроекСКД);
	
	СхемаКомпоновкиДанных.НаборыДанных.НаборДанных1.Запрос = ТекстЗапросаОригинальный;
	
	ОтчетСформирован = Истина;
	
	#Если МобильноеПриложениеСервер Тогда
	#Иначе		
		Элементы.ТабДок.ОтображатьГруппировки = Истина;
	#КонецЕсли	
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьДиаграммуСервер() 
	ДиаграммаОстатки.Очистить();
	
	МаксЗначение = Неопределено;
	МинЗначение = Неопределено;
	БазовоеЗначение = 0;
	
	ЦветаВалюты = Новый Массив;
	ЦветаВалюты.Добавить(WebЦвета.Зеленый);
	ЦветаВалюты.Добавить(WebЦвета.Желтый);
	
	СхемаКомпоновкиДанных = ПолучитьИзВременногоХранилища(ЭтотОбъект.АдресСКД);
	
	СтруктураПараметров = Новый Структура("Период, ТипДиаграммы, Периодичность, ВыводитьСериюДолги,
	|ВыводитьСериюКурса, ВычитатьДолгиИзОстатка, ВалютаКурса, ВалютаОтчета");
	
	ОтчетыСКД.ПолучитьПараметрыНастроекСКД(СхемаКомпоновкиДанных, ЭтотОбъект.АдресНастроекСКД, , , СтруктураПараметров);
	
	Если СтруктураПараметров.Периодичность <> Перечисления.Периодичность.Регистратор Тогда 
		ТекстЗапросаОригинальный = СхемаКомпоновкиДанных.НаборыДанных.НаборДанных1.Запрос;
		СхемаКомпоновкиДанных.НаборыДанных.НаборДанных1.Запрос = СтрЗаменить(ТекстЗапросаОригинальный, "МЕСЯЦ", ВРег(СтруктураПараметров.Периодичность));
	КонецЕсли;
	
	ВалютаОтчета = СтруктураПараметров.ВалютаОтчета;
	
	Если ЗначениеЗаполнено(СтруктураПараметров.ТипДиаграммы) Тогда 
		ДиаграммаОстатки.ТипДиаграммы = ТипДиаграммы[СтруктураПараметров.ТипДиаграммы];
	Иначе
		Элементы.СтраницыДиаграмм.ТекущаяСтраница = Элементы.СтраницаОстатки;
		ДиаграммаСформирована = Истина;
		Возврат; 
	КонецЕсли;
	
	ОбязательныеПоля = Новый Массив;
	
	Если ДиаграммаОстатки.ТипДиаграммы = ТипДиаграммы.БиржеваяСвеча Тогда 
		ОбязательныеПоля.Добавить("НачальныйОстатокВал");
		ОбязательныеПоля.Добавить("КонечныйОстатокВал");
		ОбязательныеПоля.Добавить("ОстатокМин");
		ОбязательныеПоля.Добавить("ОстатокМакс");
	КонецЕсли;
	
	Если СтруктураПараметров.ВыводитьСериюКурса Тогда 
		ОбязательныеПоля.Добавить("КурсДопВалюты");
	КонецЕсли;
	
	Если СтруктураПараметров.ВыводитьСериюДолги Тогда 
		ОбязательныеПоля.Добавить("ОстатокДолг");
	КонецЕсли;
	
	СтруктураПараметров.Вставить("ОбязательныеПоля", ОбязательныеПоля);
	
	Если СтруктураПараметров.Периодичность = Перечисления.Периодичность.День Тогда 
		ФорматнаяСтрокаТочки = "ДФ='ддд, дд.ММ'";
	Иначе
		ФорматнаяСтрокаТочки = "ДФ=дд.ММ.гг";
	КонецЕсли;
	
	ДанныеОтчета = Новый ДеревоЗначений;
	
	ОтчетыСКД.ПолучитьДанныеОтчета(СхемаКомпоновкиДанных, ДанныеОтчета, Неопределено, УникальныйИдентификатор,
	СтруктураПараметров, АдресДанныхРасшифровкиДиаграмма, Ложь, ЭтотОбъект.АдресНастроекСКД);
	
	СхемаКомпоновкиДанных.НаборыДанных.НаборДанных1.Запрос = ТекстЗапросаОригинальный;
	
	СоответствиеПериодовТочек = Новый Соответствие;
	
	Для Каждого ВыборкаВалюта Из ДанныеОтчета.Строки Цикл
		Серия = ДиаграммаОстатки.Серии.Добавить(ВыборкаВалюта.Валюта);
		Серия.Значение = ВыборкаВалюта.Валюта;
		Серия.Текст = ВыборкаВалюта.Валюта;
		Серия.Маркер = ТипМаркераДиаграммы.Круг;
		Серия.Цвет = WebЦвета.НасыщенноНебесноГолубой;
		Серия.ПриоритетЦвета = Истина;			
		
		Если СтруктураПараметров.ВыводитьСериюДолги Тогда 
			СерияДолг = ДиаграммаОстатки.Серии.Добавить(НСтр("ru = 'Долг'") + ВыборкаВалюта.Валюта);
			СерияДолг.Значение = "Долг";
			СерияДолг.Текст = НСтр("ru = 'Долг'") + ВыборкаВалюта.Валюта;
			СерияДолг.Маркер = ТипМаркераДиаграммы.Круг;
			СерияДолг.ПриоритетЦвета = Истина;
		КонецЕсли;
		
		Для Каждого Выборка Из ВыборкаВалюта.Строки Цикл
			ТекТочка = СоответствиеПериодовТочек.Получить(Выборка.Период); 
			
			Если ТекТочка = Неопределено Тогда 
				Точка = ДиаграммаОстатки.Точки.Добавить(Формат(Выборка.Период, форматнаяСтрокаТочки));
				
				СоответствиеПериодовТочек.Вставить(Выборка.Период, Точка);
			Иначе
				Точка = ТекТочка;
			КонецЕсли;
			
			Если ДиаграммаОстатки.ТипДиаграммы = ТипДиаграммы.БиржеваяСвеча Тогда 
				Расшифровка = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = '%1 - %2
				|Нач: %3
				|Мин: %4
				|Макс:%5
				|Кон: %6'"), Выборка.Валюта, Формат(Выборка.Период, ФорматнаяСтрокаТочки), Выборка.НачальныйОстатокВал,
				Выборка.ОстатокМин, Выборка.ОстатокМакс, Выборка.КонечныйОстатокВал);
				
				ДиаграммаОстатки.УстановитьЗначение(Точка, Серия, Выборка.НачальныйОстатокВал, Расшифровка, Расшифровка);
				
				Точка = ДиаграммаОстатки.Точки.Добавить(Формат(Выборка.Период, форматнаяСтрокаТочки));
				ДиаграммаОстатки.УстановитьЗначение(Точка, Серия, Выборка.ОстатокМакс, Расшифровка, Расшифровка);
				
				Точка = ДиаграммаОстатки.Точки.Добавить(Формат(Выборка.Период, форматнаяСтрокаТочки));
				ДиаграммаОстатки.УстановитьЗначение(Точка, Серия, Выборка.ОстатокМин, Расшифровка, Расшифровка);
				
				Точка = ДиаграммаОстатки.Точки.Добавить(Формат(Выборка.Период, форматнаяСтрокаТочки));
				ДиаграммаОстатки.УстановитьЗначение(Точка, Серия, Выборка.КонечныйОстатокВал, Расшифровка, Расшифровка);
			Иначе
				Расшифровка = Формат(Выборка.КонечныйОстатокВал, "ЧДЦ=2; ЧН=0.00") + " " + Выборка.Валюта + " - " +
				Формат(Выборка.Период, ФорматнаяСтрокаТочки);
				
				ДиаграммаОстатки.УстановитьЗначение(Точка, Серия, Выборка.КонечныйОстатокВал, Расшифровка, Расшифровка);
				
				Если СтруктураПараметров.ВыводитьСериюДолги Тогда 
					Расшифровка = Формат(Выборка.ОстатокДолг, "ЧДЦ=2; ЧН=0.00") + " " + Выборка.Валюта + " - " +
					Формат(Выборка.Период, ФорматнаяСтрокаТочки);
					ДиаграммаОстатки.УстановитьЗначение(Точка, СерияДолг, Выборка.ОстатокДолг, Расшифровка, Расшифровка);
				КонецЕсли;
			КонецЕсли;
			
			//Если ЗначениеЗаполнено(Выборка.КонечныйОстатокВал) Тогда 
			МинЗначение = ?(МинЗначение = Неопределено, Выборка.КонечныйОстатокВал, Мин(МинЗначение, Выборка.КонечныйОстатокВал));
			МаксЗначение = ?(МаксЗначение = Неопределено, Выборка.КонечныйОстатокВал, Макс(МаксЗначение, Выборка.КонечныйОстатокВал));
			//КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	Если МинЗначение <> Неопределено И МаксЗначение <> Неопределено Тогда 
		РазницаЗначений = МаксЗначение - МинЗначение;
		ОтношениеРазницыМинимума = ?(МинЗначение = 0, 1, РазницаЗначений / МинЗначение);
		
		Если ОтношениеРазницыМинимума < 2 И ОтношениеРазницыМинимума > 0 Тогда 
			МинЗначениеРасчет = МинЗначение - РазницаЗначений / 20; 
			
			РазрядностьОкругления = 0;
			ТекРазницаЗначений = РазницаЗначений;
			
			Пока ТекРазницаЗначений > 1 Цикл
				ТекРазницаЗначений = ТекРазницаЗначений / 10;
				РазрядностьОкругления = РазрядностьОкругления - 1;
			КонецЦикла;
			
			БазовоеЗначение = Окр(МинЗначениеРасчет, РазрядностьОкругления, 0); 
			
			Если БазовоеЗначение = 0 Тогда 
				БазовоеЗначение = Окр(МинЗначениеРасчет, РазрядностьОкругления + 1, 0);
			КонецЕсли;
			
			Пока БазовоеЗначение > МинЗначение Цикл 
				МинЗначениеРасчет = МинЗначениеРасчет - РазницаЗначений / 10;
				БазовоеЗначение = Окр(МинЗначениеРасчет, РазрядностьОкругления + 1, 0); 
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	
	Если ДиаграммаОстатки.ТипДиаграммы <> ТипДиаграммы.БиржеваяСвеча Тогда
		Если СтруктураПараметров.ВыводитьСериюКурса Тогда
			ПервыйПроход = Ложь;
			
			Для Каждого ВыборкаВалюта Из ДанныеОтчета.Строки Цикл
				СерияКурс = ДиаграммаОстатки.Серии.Добавить(НСтр("ru = 'Курс'") + СтруктураПараметров.ВалютаКурса);
				СерияКурс.Значение = "Курс";
				СерияКурс.Текст = НСтр("ru = 'Курс '") + СтруктураПараметров.ВалютаКурса;
				СерияКурс.Маркер = ТипМаркераДиаграммы.Круг;
				СерияКурс.ПриоритетЦвета = Истина;
				
				Для Каждого Выборка Из ВыборкаВалюта.Строки Цикл
					ТекТочка = СоответствиеПериодовТочек.Получить(Выборка.Период);
					
					Если ТекТочка = Неопределено Тогда 
						Точка = ДиаграммаОстатки.Точки.Добавить(Формат(Выборка.Период, форматнаяСтрокаТочки));
						
						СоответствиеПериодовТочек.Вставить(Выборка.Период, Точка);
					Иначе
						Точка = ТекТочка;
					КонецЕсли;
					
					Если Не ПервыйПроход Тогда 
						ПервыйПроход = Истина;
						
						Коэффициент = ?(Выборка.КурсДопВалюты = 0, 0, ((МаксЗначение + МинЗначение) / 2) / Выборка.КурсДопВалюты);
					КонецЕсли;
					
					ТекЗначение = Окр(Выборка.КурсДопВалюты * Коэффициент);
					
					Расшифровка = Формат(Выборка.КурсДопВалюты, "ЧДЦ=2; ЧН=0.00") + " - " +
					Формат(Выборка.Период, ФорматнаяСтрокаТочки);
					ДиаграммаОстатки.УстановитьЗначение(Точка, СерияКурс, ТекЗначение, Расшифровка, Расшифровка);
				КонецЦикла;
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	
	ДиаграммаОстатки.БазовоеЗначение = БазовоеЗначение;
	ДиаграммаОстатки.Обновление = Истина;
	
	Элементы.ДиаграммаОстатки.Заголовок = "Изменения с " + Формат(СтруктураПараметров.Период.ДатаНачала, "ДЛФ=DD") + " по " +
	Формат(СтруктураПараметров.Период.ДатаОкончания, "ДЛФ=DD");
	
	Если ДиаграммаОстатки.Точки.Количество() = 0 Тогда
		Элементы.СтраницыДиаграмм.ТекущаяСтраница = Элементы.СтраницаНетДанных;
	Иначе		
		Элементы.СтраницыДиаграмм.ТекущаяСтраница = Элементы.СтраницаОстатки;		
	КонецЕсли;
	
	ДиаграммаСформирована = Истина;
КонецПроцедуры

&НаСервере
Процедура ВыбратьНастройкуЗавершениеСервер() Экспорт 
	
	ОбщиеНастройкиВызовСервера.ВыбратьНастройкуЗавершениеСервер(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗакрытииНаСервере()
	
	ОбщиеНастройкиВызовСервера.СохранитьНастройкуОтчетаПриЗакрытии(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти