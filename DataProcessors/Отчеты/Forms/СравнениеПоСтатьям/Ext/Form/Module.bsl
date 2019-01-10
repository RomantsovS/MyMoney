﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ПодготовитьФормуНаСервере();
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
Процедура ТабДокОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	СтандартнаяОбработка = ложь;
	
	парам = новый Структура("отборПоСтатье, отборПоПериоду", Расшифровка, новый Структура("НачалоПериода, КонецПериода",
	Период.ДатаНачала, Период.ДатаОкончания));
	ОткрытьФорму("Документ.Операция.ФормаСписка", парам, ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура Группа2ПриСменеСтраницы(Элемент, ТекущаяСтраница)
	ОбновитьТекущуюСтраницу();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СохранитьНастройку(Команда)
	
	ОбщиеНастройкиКлиент.СохранитьНастройку(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьНастройку(Команда)
	
	ОбщиеНастройкиКлиент.ВыбратьНастройку(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьДиаграмму(Команда)
	ОбновитьТекущуюСтраницу();
КонецПроцедуры

&НаКлиенте
Процедура Настройки(Команда)
	
	ОП = Новый ОписаниеОповещения("НастройкаПослеИзменения", ЭтаФорма);
	
	ОткрытьФорму("Обработка.Отчеты.Форма.СравнениеПоСтатьямНастройки", ПолучитьСтруктуруНастроекКСохранению(), , , , , ОП);
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьЗначенияДиаграммы(Команда)
	ПроверитьЗначенияДиаграммыНаСервере();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура СформироватьОборотыПокатегориямСерв()
	Запрос = новый Запрос("ВЫБРАТЬ
	|	ЗатратыОбороты.Валюта,
	|	ЗатратыОбороты.СуммаОборот КАК Сумма
	|ПОМЕСТИТЬ вт
	|ИЗ
	|	РегистрНакопления.Затраты.Обороты(
	|			&НачалоПериода,
	|			&КонецПериода,
	|			Авто,
	|			(&НеИспользоватьОтборКошелек
	|				ИЛИ Кошелек В (&ОтборКошелек))
	|				И (&НеИспользоватьОтборМетка
	|					ИЛИ Метка В (&ОтборМетка))
	|				И (&НеИспользоватьОтборСтатья
	|					ИЛИ Статья В ИЕРАРХИИ (&ОтборСтатья))
	|				И (&НеИспользоватьОтборТипОперации
	|					ИЛИ ТипОперации В (&ОтборТипОперации))
	|				И (&НеИспользоватьОтборВалюта
	|					ИЛИ Валюта В (&ОтборВалюта))) КАК ЗатратыОбороты
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	вт.Валюта КАК Валюта,
	|	вт.Сумма КАК Сумма
	|ИЗ
	|	вт КАК вт
	|
	|УПОРЯДОЧИТЬ ПО
	|	Валюта
	|ИТОГИ
	|	СУММА(Сумма)
	|ПО
	|	Валюта");
	
	Запрос.УстановитьПараметр("НачалоПериода", Период.ДатаНачала);
	Запрос.УстановитьПараметр("КонецПериода", ?(Период.ДатаОкончания = дата(1, 1, 1), Период.ДатаОкончания, КонецДня(Период.ДатаОкончания)));
	
	резВалюта = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	макет = РеквизитФормыВЗначение("Объект").получитьМакет("Макет");
	ТабДок.Очистить();
	
	облШапка = макет.получитьОбласть("Шапка");
	
	первыйПроходШапки = Истина;
	
	облШапка.параметры.измерение = "Измерения";
	облШапка.параметры.сумма = "Сумма";
	ТабДок.Вывести(облШапка);
	
	облСтрокаВалюта = макет.получитьОбласть("СтрокаВалюта");
	
	ТабДок.НачатьАвтогруппировкуСтрок();
	
	Пока резВалюта.Следующий() Цикл
		облСтрокаВалюта.параметры.измерение = резВалюта.Валюта;
		облСтрокаВалюта.параметры.Сумма = резВалюта.Сумма;
		
		ТабДок.Вывести(облСтрокаВалюта, 1);
		
		рез2 = резВалюта.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией);
	КонецЦикла;	
	
	ТабДок.ЗакончитьАвтогруппировкуСтрок(); 
	
	#Если МобильноеПриложениеСервер Тогда
	    процентШириныКолонок = 70;
	#Иначе
	    процентШириныКолонок = 100;    
		Элементы.ТабДок.ОтображатьГруппировки = Истина;
	#КонецЕсли
	
	РеквизитФормыВЗначение("Объект").РасчетШириныКолонок(ТабДок, процентШириныКолонок);
КонецПроцедуры

&НаСервере
Процедура ОбновитьДиаграммуРасходыСервер(ДиаграммаСформирована)
	НашаДиаграмма.Очистить();
	НашаДиаграмма.Обновление = ложь;
	
	МаксЗначение = Неопределено;
	МинЗначение = Неопределено;
	БазовоеЗначение = 0;
	
	Если Периодичность = Перечисления.Периодичность.День Тогда 
		ФорматнаяСтрокаТочки = "ДФ='ддд, дд.ММ'";
	Иначе
		ФорматнаяСтрокаТочки = "ДФ=дд.ММ.гг";
	КонецЕсли;
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	|	ЗатратыОбороты.Статья,
	|	ВЫБОР
	|		КОГДА ЗатратыОбороты.СуммаОборот < 0
	|			ТОГДА -ЗатратыОбороты.СуммаОборот
	|		ИНАЧЕ ЗатратыОбороты.СуммаОборот
	|	КОНЕЦ КАК Сумма,
	|	ЗатратыОбороты.Период
	|ПОМЕСТИТЬ вт
	|ИЗ
	|	РегистрНакопления.Затраты.Обороты(
	|			&НачалоПериода,
	|			&КонецПериода,
	|			ДЕНЬ,
	|			(&НеИспользоватьОтбор
	|				ИЛИ Статья В (&Отбор))
	|				И (&НеИспользоватьДопОтбор
	|					ИЛИ ТипОперации В (&ДопОтбор))) КАК ЗатратыОбороты
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	вт.Статья КАК текГруппировка,
	|	СУММА(вт.Сумма) КАК Сумма,
	|	ПРЕДСТАВЛЕНИЕ(вт.Статья) КАК текГруппировкаПредставление,
	|	вт.Период КАК Период
	|ИЗ
	|	вт КАК вт
	|
	|СГРУППИРОВАТЬ ПО
	|	вт.Статья,
	|	вт.Период
	|
	|УПОРЯДОЧИТЬ ПО
	|	Период
	|ИТОГИ
	|	СУММА(Сумма)
	|ПО
	|	текГруппировка,
	|	Период ПЕРИОДАМИ(ДЕНЬ, , )");
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "ДЕНЬ", Периодичность);
	
	Если ТекГруппировка = "ГруппыСтатей" Тогда 
		ТекГруппировкаВЗапрос = "Статья";
		
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "Статья В (&Отбор)", "Статья В ИЕРАРХИИ (&Отбор)");
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "вт.Статья", "вт.Статья.родитель");		
	Иначе
		ТекГруппировкаВЗапрос = ТекГруппировка;		
	КонецЕсли;
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "Статья", ТекГруппировкаВЗапрос);	
	
	Запрос.УстановитьПараметр("НачалоПериода", Период.ДатаНачала);
	Запрос.УстановитьПараметр("КонецПериода", ?(Период.ДатаОкончания = дата(1, 1, 1), Период.ДатаОкончания, КонецДня(Период.ДатаОкончания)));
	Запрос.УстановитьПараметр("Отбор", ?(ОтборСписок.Количество() = 0, Неопределено, ОтборСписок));
	Запрос.УстановитьПараметр("ДопОтбор", ?(ДопОтборСписок.Количество() = 0, Неопределено, ДопОтборСписок));
	Запрос.УстановитьПараметр("НеИспользоватьОтбор", ОтборСписок.Количество() = 0);
	Запрос.УстановитьПараметр("НеИспользоватьДопОтбор", ДопОтборСписок.Количество() = 0);
	
	резСтатья = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	соответствиеПериодовТочек = новый Соответствие;
	
	Пока резСтатья.Следующий() Цикл
		Серия = НашаДиаграмма.Серии.Добавить(резСтатья.текГруппировкаПредставление);
		Серия.Значение = резСтатья.текГруппировка;
		Серия.Текст = резСтатья.текГруппировкаПредставление;
		
		выборка = резСтатья.выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, "Период", "ВСЕ");
		
		Пока Выборка.Следующий() Цикл			
			текТочка = соответствиеПериодовТочек.Получить(выборка.Период); 
			
			Если текТочка = Неопределено Тогда 
				Точка = НашаДиаграмма.Точки.Добавить(Формат(Выборка.Период, форматнаяСтрокаТочки));
				
				соответствиеПериодовТочек.Вставить(выборка.Период, точка);
			Иначе
				Точка = текТочка;
			КонецЕсли;
			
			НашаДиаграмма.УстановитьЗначение(Точка, Серия, Выборка.сумма, Выборка.сумма, Формат(Выборка.сумма, "ЧДЦ=2; ЧН=0.00"));
			
			Если ЗначениеЗаполнено(выборка.сумма) Тогда 
				МинЗначение = ?(МинЗначение = Неопределено, выборка.сумма, Мин(МинЗначение, выборка.сумма));
				МаксЗначение = ?(МаксЗначение = Неопределено, выборка.сумма, Макс(МаксЗначение, выборка.сумма));
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	Если МинЗначение <> Неопределено и МаксЗначение <> Неопределено Тогда 
		разницаЗначений = МаксЗначение - МинЗначение;
		отношениеРазницыМинимума = ?(МинЗначение = 0, 1, разницаЗначений / МинЗначение);
		
		Если отношениеРазницыМинимума < 2 и отношениеРазницыМинимума > 0 Тогда 
			минЗначениеРасчет = МинЗначение - разницаЗначений / 20; 
			
			разрядностьОкругления = 0;
			текРазницаЗначений = разницаЗначений;
			
			Пока текРазницаЗначений > 1 Цикл
				текРазницаЗначений = текРазницаЗначений / 10;
				разрядностьОкругления = разрядностьОкругления - 1;
			КонецЦикла;
			
			БазовоеЗначение = Окр(минЗначениеРасчет, разрядностьОкругления, 0); 
			
			Если БазовоеЗначение = 0 Тогда 
				БазовоеЗначение = Окр(минЗначениеРасчет, разрядностьОкругления + 1, 0);
			КонецЕсли;
			
			Пока БазовоеЗначение > МинЗначение Цикл 
				минЗначениеРасчет = минЗначениеРасчет - разницаЗначений / 10;
				БазовоеЗначение = Окр(минЗначениеРасчет, разрядностьОкругления + 1, 0); 
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	
	НашаДиаграмма.БазовоеЗначение = БазовоеЗначение;
	НашаДиаграмма.Обновление = Истина;
	
	элементы.Декорация1.Заголовок = формат(Период.датаНачала, "ДФ=dd.МММyyyy; ДЛФ=DD") + " по " +
	формат(Период.датаОкончания, "ДФ=dd.МММyyyy; ДЛФ=DD");
	
	Если НашаДиаграмма.Точки.Количество() = 0 Тогда
		Элементы.СтраницыДиаграмм.ТекущаяСтраница = Элементы.СтраницаНетДанных;
	Иначе		
		Элементы.СтраницыДиаграмм.ТекущаяСтраница = Элементы.СтраницаОстатки;		
	КонецЕсли;
	
	ДиаграммаСформирована = Истина;
КонецПроцедуры

&НаСервере
Процедура СохранитьНастройкуНаСервере(КлючНастроек, ИмяНастройки) Экспорт 
	ОбщиеНастройкиВызовСервера.СохранитьНастройкуНаСервере(КлючОбъекта, КлючНастроек, ИмяНастройки,
	ПолучитьСтруктуруНастроекКСохранению());
КонецПроцедуры

&НаСервере
Функция ПолучитьСтруктуруНастроекКСохранению() Экспорт 
	
	СтруктураНастроек = Новый Структура;
	СтруктураНастроек.Вставить("Период", Период);
	СтруктураНастроек.Вставить("Периодичность", Периодичность);
	СтруктураНастроек.Вставить("ОтборСписок", ОтборСписок);
	СтруктураНастроек.Вставить("ДопОтборСписок", ДопОтборСписок);
	СтруктураНастроек.Вставить("ТекГруппировка", ТекГруппировка);
	
	Возврат СтруктураНастроек;
	
КонецФункции

&НаСервере
Процедура ВыбратьНастройкуЗавершениеСервер() Экспорт 
	Если ОбщегоНазначения.ЕстьРеквизитОбъекта(ЭтотОбъект, "ОтчетСформирован") Тогда 
		ОтчетСформирован = Ложь;
	КонецЕсли;
	
	Если ОбщегоНазначения.ЕстьРеквизитОбъекта(ЭтотОбъект, "ДиаграммаСформирована") Тогда 
		ДиаграммаСформирована = Ложь;
	КонецЕсли;
	
	Настройка = ОбщиеНастройкиВызовСервера.ОбщиеНастройкиЗагрузить(КлючОбъекта, ТекНастройка);
	
	ОбщиеНастройкиВызовСервера.ЗагрузитьНастройку(ЭтотОбъект, Настройка);
КонецПроцедуры

&НаСервере
Функция ЕстьКлючНастроекПоНаименованиюСервер(имяНастройки) Экспорт 	
	поискНастройки = Справочники.КлючНастроек.НайтиПоКоду(имяНастройки);
	
	Возврат ЗначениеЗаполнено(поискНастройки);
КонецФункции

&НаСервере
Процедура НастроитьОформлениеДиаграммы()
	ШрифтПодписей = Новый Шрифт(ШрифтыСтиля.МелкийШрифтТекста);
	
	НашаДиаграмма.ШрифтПодписей = ШрифтПодписей;
	
	НашаДиаграмма.ОбластьПостроения.Шрифт = ШрифтПодписей;
	НашаДиаграмма.ОбластьПостроения.Верх = 0;
	НашаДиаграмма.ОбластьПостроения.Лево = 0;
	НашаДиаграмма.ОбластьПостроения.Низ = 1;
	НашаДиаграмма.ОбластьПостроения.Право = 1;
	
	НашаДиаграмма.ОбластьПостроения.ЦветШкалы = WebЦвета.Черный;
	
	НашаДиаграмма.ФорматЗначенийВПодписях  = "ЧДЦ=2; ЧРГ=.";
	
	НашаДиаграмма.ТипДиаграммы = ТипДиаграммы.ГистограммаОбъемная;
КонецПроцедуры

&НаСервере
Процедура ПодготовитьФормуНаСервере()		
	КлючОбъекта = Метаданные.Обработки.Отчеты.Имя + ЭтаФорма.ИмяФормы;
	
	Периодичность = Перечисления.Периодичность.Месяц;
	
	Период.ДатаНачала = НачалоГода(ТекущаяДата());
	Период.ДатаОкончания = КонецМесяца(ТекущаяДата());
	
	ТекГруппировка = "Статья";
	
	НастроитьОформлениеДиаграммы();
	
	ОбщиеНастройкиВызовСервера.ЗагрузитьОсновнуюНастройку(ЭтотОбъект);
	
	ОбновитьТекущуюСтраницу();
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьНастройкуДоп(Настройка) Экспорт 
	
	ДопОтборСписок.ЗагрузитьЗначения(Настройка.ДопОтборСписок.ВыгрузитьЗначения());
	Периодичность = Настройка.Периодичность;
	ТекГруппировка = Настройка.ТекГруппировка;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьТекущуюСтраницу()
	Если Элементы.Группа2.ТекущаяСтраница = Элементы.ГруппаДиаграммы Тогда
		Если Не ДиаграммаСформирована Тогда 
			ОбновитьДиаграммуРасходыСервер(ДиаграммаСформирована);
		КонецЕсли;
	Иначе
		Если не ОтчетСформирован Тогда 
			СформироватьОборотыПокатегориямСерв();
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПроверитьЗначенияДиаграммыНаСервере()
	Для Каждого стрТочка из НашаДиаграмма.Точки Цикл
		Для Каждого стрСерия из НашаДиаграмма.Серии Цикл
			значДиаграммы = НашаДиаграмма.ПолучитьЗначение(стрТочка, стрСерия);
			
			Сообщить("" + значДиаграммы.серия.текст + " " + значДиаграммы.точка.текст + " " + значДиаграммы.значение);
		КонецЦикла;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура НастройкаПослеИзменения(Результат, допПараметры) Экспорт 
	Если Результат <> Неопределено Тогда 
		Период = Результат.Период;
		Периодичность = Результат.Периодичность;
		ОтборСписок.ЗагрузитьЗначения(результат.ОтборСписок.выгрузитьЗначения());
		ТекГруппировка = результат.текГруппировка;
		ДопОтборСписок.ЗагрузитьЗначения(результат.ДопОтборСписок.выгрузитьЗначения());
		
		НастройкаПослеИзмененияСерв();
		
		Если Элементы.Группа2.ТекущаяСтраница = Элементы.ГруппаДиаграммы Тогда
			ДиаграммаСформирована = Истина;			
			ОтчетСформирован = ложь;
		Иначе
			ДиаграммаСформирована = ложь;
			ОтчетСформирован = Истина;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура НастройкаПослеИзмененияСерв()
	ДиаграммаСформирована = ложь;			
	ОтчетСформирован = ложь;
	
	ОбновитьТекущуюСтраницу();
КонецПроцедуры

&НаСервере
Процедура ПриЗакрытииНаСервере()
	
	ОбщиеНастройкиВызовСервера.СохранитьНастройкуОтчетаПриЗакрытии(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти