﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("ОтборВалюта") Тогда 
		ОтборВалюта.ЗагрузитьЗначения(Параметры.ОтборВалюта.ВыгрузитьЗначения());
	Иначе
		Элементы.ОтборВалюта.Видимость = Ложь;
	КонецЕсли;
	
	Если Параметры.Свойство("ОтборКошелек") Тогда 
		ОтборКошелек.ЗагрузитьЗначения(Параметры.ОтборКошелек.ВыгрузитьЗначения());
	Иначе
		Элементы.ОтборКошелек.Видимость = Ложь;
	КонецЕсли;
	
	Период = Параметры.Период;
	Периодичность = Параметры.Периодичность;
	ВалютаОтчета = Параметры.ВалютаОтчета;
	ВалютаКурса = Параметры.ВалютаКурса;
	ВыводитьСериюКурса = Параметры.ВыводитьСериюКурса;
	
	Если Параметры.Свойство("ВыводитьСериюДолги", ВыводитьСериюДолги) Тогда 
		Элементы.ВыводитьСериюДолги.Видимость = Истина;
	КонецЕсли;
	
	Если Параметры.Свойство("ВычитатьДолгиИзОстатка", ВычитатьДолгиИзОстатка) Тогда 
		Элементы.ВычитатьДолгиИзОстатка.Видимость = Истина;
	КонецЕсли;
	
	Если ОтборКошелек.Количество() = 1 Тогда 
				
	КонецЕсли;
	
	Если Параметры.Свойство("ТипОтображаемойДиаграммы", ТипОтображаемойДиаграммы) Тогда 
		Элементы.ТипОтображаемойДиаграммы.Видимость = Истина;
		
		ЗаполнитьСписокВыбораТипаДиаграммы();
	КонецЕсли;
	
	ОтборКошелекПриИзмененииСервер();
	
	ПриИзмененииТипаДиаграммы();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УстановитьДоступность();
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если ВыводитьСериюКурса Тогда 
		ПроверяемыеРеквизиты.Добавить("ВалютаКурса");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ОтборКошелекНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ОткрытьФорму("Обработка.Отчеты.Форма.ФормаВыбора", Новый Структура("ИмяМетаданных, Список", "Справочник.Кошельки",
	ОтборКошелек.ВыгрузитьЗначения()), ЭтаФорма, , , , Новый ОписаниеОповещения("ОтборВыборЗавершение", ЭтотОбъект, ОтборКошелек),
	РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборВалютаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ОткрытьФорму("Обработка.Отчеты.Форма.ФормаВыбора", Новый Структура("ИмяМетаданных, Список", "Справочник.Валюты",
	ОтборВалюта.ВыгрузитьЗначения()), ЭтаФорма, , , , Новый ОписаниеОповещения("ОтборВыборЗавершение", ЭтотОбъект, ОтборВалюта),
	РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборКошелекПриИзменении(Элемент)
	
	ОтборКошелекПриИзмененииСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодичностьПриИзменении(Элемент)
	
	ЗаполнитьСписокВыбораТипаДиаграммы();
	
	Если Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Неделя") Тогда 
		Период.ДатаНачала = НачалоНедели(Период.ДатаНачала);
	ИначеЕсли Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Месяц") Тогда 
		Период.ДатаНачала = НачалоМесяца(Период.ДатаНачала);
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ВыводитьСериюКурсаПриИзменении(Элемент)
	
	УстановитьДоступность();
	
КонецПроцедуры

&НаКлиенте
Процедура ТипОтображаемойДиаграммыПриИзменении(Элемент)
	
	ПриИзмененииТипаДиаграммы();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Готово(Команда)
	Если Не ПроверитьЗаполнение() Тогда 
		Возврат;
	КонецЕсли;
	
	СтруктаНастроек = Новый Структура;
	СтруктаНастроек.Вставить("ОтборВалюта", ОтборВалюта);
	СтруктаНастроек.Вставить("ОтборКошелек", ОтборКошелек);
	СтруктаНастроек.Вставить("Период", Период);
	СтруктаНастроек.Вставить("Периодичность", Периодичность);
	СтруктаНастроек.Вставить("ВалютаОтчета", ВалютаОтчета);
	СтруктаНастроек.Вставить("ОтображатьСериюДолги", ВыводитьСериюДолги);
	СтруктаНастроек.Вставить("ВычитатьДолгиИзОстатка", ВычитатьДолгиИзОстатка);
	СтруктаНастроек.Вставить("ВалютаКурса", ВалютаКурса);
	СтруктаНастроек.Вставить("ВыводитьСериюКурса", ВыводитьСериюКурса);
	СтруктаНастроек.Вставить("ТипОтображаемойДиаграммы", ТипОтображаемойДиаграммы);
	
	ЭтаФорма.Закрыть(СтруктаНастроек);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОтборВыборЗавершение(Результат, ДопПараметры) Экспорт 
	Если ТипЗнч(Результат) = Тип("СписокЗначений") Тогда 
		ДопПараметры.ЗагрузитьЗначения(Результат.ВыгрузитьЗначения());
		
		Если ОтборКошелек = ДопПараметры Тогда 
			ОтборКошелекПриИзмененииСервер();
		КонецЕсли;
	КонецЕсли;	
КонецПроцедуры

&НаСервере
Процедура ОтборКошелекПриИзмененииСервер()
	
	Элементы.Периодичность.СписокВыбора.Очистить();
	
	Если ОтборКошелек.Количество() <> 1 Тогда 
		Если Периодичность = Перечисления.Периодичность.Регистратор Тогда 
			Периодичность = Перечисления.Периодичность.ПустаяСсылка();
		КонецЕсли;
		
		Если Элементы.Найти("ВычитатьДолгиИзОстатка") <> Неопределено Тогда 
			Элементы.ВычитатьДолгиИзОстатка.ТолькоПросмотр = Ложь;
		КонецЕсли;
	Иначе
		ВычитатьДолгиИзОстатка = Ложь;
		
		Если Элементы.Найти("ВычитатьДолгиИзОстатка") <> Неопределено Тогда 
			Элементы.ВычитатьДолгиИзОстатка.ТолькоПросмотр = Истина;
		КонецЕсли;
		
		Элементы.Периодичность.СписокВыбора.Добавить(Перечисления.Периодичность.Регистратор, "Регистратор");
	КонецЕсли;
	
	Элементы.Периодичность.СписокВыбора.Добавить(Перечисления.Периодичность.День, "День");
	Элементы.Периодичность.СписокВыбора.Добавить(Перечисления.Периодичность.Неделя, "Неделя");
	Элементы.Периодичность.СписокВыбора.Добавить(Перечисления.Периодичность.Декада, "Декада");
	Элементы.Периодичность.СписокВыбора.Добавить(Перечисления.Периодичность.Месяц, "Месяц");
	Элементы.Периодичность.СписокВыбора.Добавить(Перечисления.Периодичность.Квартал, "Квартал");
	Элементы.Периодичность.СписокВыбора.Добавить(Перечисления.Периодичность.Полугодие, "Полугодие");
	Элементы.Периодичность.СписокВыбора.Добавить(Перечисления.Периодичность.Год, "Год");
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДоступность()
	
	Элементы.ВалютаКурса.ТолькоПросмотр = Не ВыводитьСериюКурса;
	Элементы.ВалютаКурса.АвтоОтметкаНезаполненного = ВыводитьСериюКурса;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокВыбораТипаДиаграммы()
	
	Если Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Регистратор") Тогда 
		Если ТипОтображаемойДиаграммы = ТипДиаграммы.БиржеваяСвеча Тогда 
			ТипОтображаемойДиаграммы = ТипДиаграммы.График;
		КонецЕсли;
		
		Элементы.ТипОтображаемойДиаграммы.СписокВыбора.Очистить();
		Элементы.ТипОтображаемойДиаграммы.СписокВыбора.Добавить(ТипДиаграммы.График, НСтр("ru = 'График'"));
	Иначе
		Элементы.ТипОтображаемойДиаграммы.СписокВыбора.Очистить();
		Элементы.ТипОтображаемойДиаграммы.СписокВыбора.Добавить(ТипДиаграммы.График, НСтр("ru = 'График'"));
		Элементы.ТипОтображаемойДиаграммы.СписокВыбора.Добавить(ТипДиаграммы.ГрафикПоШагам, НСтр("ru = 'График по шагам'"));
		Элементы.ТипОтображаемойДиаграммы.СписокВыбора.Добавить(ТипДиаграммы.БиржеваяСвеча, НСтр("ru = 'Биржевая свеча'"));
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриИзмененииТипаДиаграммы()
	
	ОтображатьДолгиКурсы = ТипОтображаемойДиаграммы <> ТипДиаграммы.БиржеваяСвеча;
	
	Элементы.ВыводитьСериюКурса.ТолькоПросмотр = Не ОтображатьДолгиКурсы;
	Элементы.ВыводитьСериюДолги.ТолькоПросмотр = Не ОтображатьДолгиКурсы;
	
	Если Не ОтображатьДолгиКурсы Тогда 
		ВыводитьСериюДолги = Ложь;
		ВыводитьСериюКурса = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти