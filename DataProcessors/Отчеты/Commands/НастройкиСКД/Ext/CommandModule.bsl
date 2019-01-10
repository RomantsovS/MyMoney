﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Форма = ПараметрыВыполненияКоманды.Источник;
	
	ЗаголовокФормыНастройкиСхемыКомпоновкиДанных = НСтр("ru = 'Настройки отчета ""%ИмяОтчета%""'");
	ЗаголовокФормыНастройкиСхемыКомпоновкиДанных = СтрЗаменить(ЗаголовокФормыНастройкиСхемыКомпоновкиДанных, "%ИмяОтчета%",
	Форма.Заголовок);
	
	Результат = Неопределено;
	
	ПараметрыОткрытияФормы = Новый Структура;
	ПараметрыОткрытияФормы.Вставить("АдресСхемыКомпоновкиДанных", Форма.АдресСКД);
	ПараметрыОткрытияФормы.Вставить("АдресНастроекКомпоновкиДанных", Форма.АдресНастроекСКД);
	//ПараметрыОткрытияФормы.Вставить("ИсточникШаблонов", Объект.Ссылка);
	ПараметрыОткрытияФормы.Вставить("Заголовок", ЗаголовокФормыНастройкиСхемыКомпоновкиДанных);
	ПараметрыОткрытияФормы.Вставить("НеНастраиватьУсловноеОформление", Ложь);
	ПараметрыОткрытияФормы.Вставить("НеНастраиватьПорядок", Ложь);
	ПараметрыОткрытияФормы.Вставить("НеНастраиватьВыбор",
	?(ОбщегоНазначенияКлиентСервер.ЕстьРеквизитОбъекта(Форма, "НеНастраиватьВыбор") = Истина, Форма.НеНастраиватьВыбор, Ложь));
	ПараметрыОткрытияФормы.Вставить("УникальныйИдентификатор", Форма.УникальныйИдентификатор);
	//ПараметрыОткрытияФормы.Вставить("ИмяШаблонаСКД", Объект.ИмяШаблонаСКД);
	ПараметрыОткрытияФормы.Вставить("ВозвращатьИмяТекущегоШаблонаСКД", Истина);
		
	ОткрытьФорму("Обработка.Отчеты.Форма.УпрощеннаяНастройкаСхемыКомпоновкиДанных", ПараметрыОткрытияФормы,
	ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно,
	ПараметрыВыполненияКоманды.НавигационнаяСсылка, Новый ОписаниеОповещения("НастройкиЗавершение", ЭтотОбъект,
	Новый Структура("Форма", Форма)), РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкиЗавершение(АдресХранилищаНастройкиКомпоновщика, ДопПараметры) Экспорт 
	
	Если АдресХранилищаНастройкиКомпоновщика <> Неопределено Тогда 
		Форма = ДопПараметры.Форма;
        
        Изменения = ОтчетыСКД.ПрименитьИзмененияКСхемеКомпоновкиДанных(Форма.АдресСКД, АдресХранилищаНастройкиКомпоновщика,
		Форма.УникальныйИдентификатор);
		
		Форма.АдресНастроекСКД = Изменения.АдресНастроекСКД;
		
		Форма.ОтчетСформирован = Ложь;
		Форма.ДиаграммаСформирована = Ложь;
		
		Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитОбъекта(Форма, "СтруктураКомпоновки") Тогда
			Форма.СтруктураКомпоновки.Очистить();
		КонецЕсли;
		
		Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитОбъекта(Форма, "ОтборДопВалюта") Тогда
			Форма.ОтборДопВалюта.Очистить();
		КонецЕсли;
		
		Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитОбъекта(Форма, "ОтборДопКошелек") Тогда
			Форма.ОтборДопКошелек.Очистить();
		КонецЕсли;
		
		Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитОбъекта(Форма, "ОтборДопМетка") Тогда
			Форма.ОтборДопМетка.Очистить();
		КонецЕсли;
		
		Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитОбъекта(Форма, "ОтборДопСтатья") Тогда
			Форма.ОтборДопСтатья.Очистить();
		КонецЕсли;
		
		Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитОбъекта(Форма, "ОтборДопТипОперации") Тогда
			Форма.ОтборДопТипОперации.Очистить();
		КонецЕсли;
		
		Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитОбъекта(Форма, "ТекУровеньГруппировки") Тогда
			Форма.ТекУровеньГруппировки = 0;
		КонецЕсли;
		
		Форма.ОбновитьТекущуюСтраницу();		
	КонецЕсли;
	
КонецПроцедуры
