﻿&НаСервере
Процедура НастроитьОформлениеДиаграммы()
	ШрифтПодписей = Новый Шрифт(ШрифтыСтиля.МелкийШрифтТекста);
	
	ДиаграммаОстатки.ШрифтПодписей = ШрифтПодписей;
	
	ДиаграммаОстатки.ОбластьПостроения.Шрифт = ШрифтПодписей;
	ДиаграммаОстатки.ОбластьПостроения.Верх = 0;
	ДиаграммаОстатки.ОбластьПостроения.Лево = 0;
	ДиаграммаОстатки.ОбластьПостроения.Низ = 1;
	ДиаграммаОстатки.ОбластьПостроения.Право = 1;
	
	ДиаграммаОстатки.ОбластьПостроения.ЦветШкалы = WebЦвета.Черный;
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)	
	ПодготовитьФормуНаСервере();
КонецПроцедуры

&НаСервере
Процедура ПодготовитьФормуНаСервере()
	Периодичность = Перечисления.Периодичность.Неделя;
	
	период.ДатаНачала = НачалоДня(ТекущаяДата()) - 3600 * 24 * 365;
	Период.ДатаОкончания = КонецДня(ТекущаяДата());
	
	НастроитьОформлениеДиаграммы();
	ОбновитьТекущуюСтраницу();
КонецПроцедуры

&НаКлиенте
Процедура Настройки(Команда)
	
	СтруктураОтбора = Новый Структура;
	СтруктураОтбора.Вставить("ОтборКошелек", ОтборКошелек);
	
	ОП = Новый ОписаниеОповещения("НастройкаОтбораПослеИзменения", ЭтаФорма);
	
	ОткрытьФорму("Обработка.Отчеты.Форма.НастройкиОтбора", СтруктураОтбора, , , , , ОП);
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкаОтбораПослеИзменения(Результат, допПараметры) Экспорт 
	Если Результат <> Неопределено Тогда 
		ОтборКошелек = Результат.ОтборКошелек;
		
		НастройкаОтбораПослеИзмененияСерв();
		
		Если Элементы.Группа2.ТекущаяСтраница = Элементы.ГруппаДиаграммы Тогда
			ДиаграммаСформирована = Истина;			
			ОтчетСформирован = Ложь;
		Иначе
			ДиаграммаСформирована = Ложь;
			ОтчетСформирован = Истина;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура НастройкаОтбораПослеИзмененияСерв()
	ДиаграммаСформирована = Ложь;			
	ОтчетСформирован = Ложь;
	
	ОбновитьТекущуюСтраницу();
КонецПроцедуры

&НаКлиенте
Процедура КошелекПриИзменении(Элемент)	
	КошелекПриИзмененииСерв();
КонецПроцедуры

&НаСервере
Процедура КошелекПриИзмененииСерв()
	ДиаграммаСформирована = Ложь;			
	ОтчетСформирован = Ложь;
	
	ОбновитьТекущуюСтраницу();
КонецПроцедуры

&НаКлиенте
Процедура Группа2ПриСменеСтраницы(Элемент, ТекущаяСтраница)
	Группа2ПриСменеСтраницыСерв();	
КонецПроцедуры

&НаСервере
Процедура Группа2ПриСменеСтраницыСерв()
	ОбновитьТекущуюСтраницу();	
КонецПроцедуры

&НаСервере
Процедура ОбновитьТекущуюСтраницу()
	Если Элементы.Группа2.ТекущаяСтраница = Элементы.ГруппаДиаграммы Тогда
		Если Не ДиаграммаСформирована Тогда 
			РеквизитФормыВЗначение("Объект").ОбновитьДиаграммуСервер();
		КонецЕсли;
	Иначе
		Если Не ОтчетСформирован Тогда 
			ОбновитьОстаткиСервер();
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ОбновитьОстаткиСервер() Экспорт 
	Запрос = Новый Запрос;
	МВТ = Новый МенеджерВременныхТаблиц;
	Запрос.МенеджерВременныхТаблиц = МВТ; 
	Запрос.УстановитьПараметр("Дата1", Период.ДатаНачала);
	Запрос.УстановитьПараметр("Дата2", Период.ДатаОкончания);
	Запрос.УстановитьПараметр("ВалютаУчета", ЗначениеНастроекВызовСервераПовтИсп.ПолучитьЗначениеКонстанты("ВалютаУчета"));
	Запрос.УстановитьПараметр("ОтборКошелек", ?(ОтборКошелек.Количество() = 0, Неопределено, ОтборКошелек));
	Запрос.УстановитьПараметр("НеИспользоватьОтборКошелек", ОтборКошелек.Количество() = 0);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПродажиВалютыОбороты.Валюта,
	|	ПродажиВалютыОбороты.Кошелек,
	|	ПродажиВалютыОбороты.Партия,
	|	ПродажиВалютыОбороты.Курс КАК Курс,
	|	ПродажиВалютыОбороты.Сумма,
	|	ПродажиВалютыОбороты.СуммаРуб,
	|	ПродажиВалютыОбороты.Регистратор КАК Регистратор,
	|	ПродажиВалютыОбороты.Период
	|ПОМЕСТИТЬ вт
	|ИЗ
	|	РегистрНакопления.ПродажиВалюты КАК ПродажиВалютыОбороты
	|ГДЕ
	|	(ПродажиВалютыОбороты.Кошелек В (&ОтборКошелек)
	|			ИЛИ &НеИспользоватьОтборКошелек)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПокупкиВалютыОбороты.Валюта,
	|	ПокупкиВалютыОбороты.Кошелек,
	|	ПокупкиВалютыОбороты.Партия,
	|	ПокупкиВалютыОбороты.Партия.Курс КАК КурсПокупки,
	|	ПокупкиВалютыОбороты.СуммаОборот КАК СуммаПокупки,
	|	ПокупкиВалютыОбороты.СуммаРубОборот КАК СуммаПокупкиРуб
	|ПОМЕСТИТЬ втПокупка
	|ИЗ
	|	РегистрНакопления.ПокупкиВалюты.Обороты(
	|			,
	|			,
	|			,
	|			(Валюта, партия) В
	|				(ВЫБРАТЬ
	|					вт.Валюта,
	|					вт.Партия
	|				ИЗ
	|					вт)) КАК ПокупкиВалютыОбороты
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	вт.Валюта КАК Валюта,
	|	вт.Кошелек КАК Кошелек,
	|	вт.Партия КАК Партия,
	|	втПокупка.КурсПокупки,
	|	ПРЕДСТАВЛЕНИЕ(вт.Валюта) КАК ВалютаПредставление,
	|	вт.Курс КАК Курс,
	|	вт.Сумма КАК СуммаПродажи,
	|	вт.Сумма * (вт.Курс - втПокупка.КурсПокупки) КАК ПрибыльУбыток,
	|	вт.СуммаРуб КАК СуммаПродажиРуб,
	|	втПокупка.СуммаПокупки КАК СуммаПокупкиВал,
	|	втПокупка.СуммаПокупкиРуб КАК СуммаПокупкиРуб,
	|	вт.Регистратор КАК Регистратор,
	|	вт.Период КАК Период
	|ИЗ
	|	вт КАК вт
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ втПокупка КАК втПокупка
	|		ПО вт.Валюта = втПокупка.Валюта
	|			И вт.Партия = втПокупка.Партия
	|
	|УПОРЯДОЧИТЬ ПО
	|	вт.Партия.Дата
	|ИТОГИ
	|	СУММА(СуммаПродажи),
	|	СУММА(ПрибыльУбыток),
	|	СУММА(СуммаПродажиРуб),
	|	СУММА(СуммаПокупкиВал),
	|	СУММА(СуммаПокупкиРуб),
	|	МАКСИМУМ(Период)
	|ПО
	|	ОБЩИЕ,
	|	Валюта,
	|	Кошелек,
	|	Партия";
	
	РезультатЗапроса = запрос.Выполнить();
	ВыборкаОбщийИтог = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	ТабДок = Новый ТабличныйДокумент;
	
	Макет = РеквизитФормыВЗначение("Объект").ПолучитьМакет("МакетПродажиПартииВалют");
	
	Если ВыборкаОбщийИтог.Следующий() Тогда 
		облШапка = Макет.получитьОбласть("Шапка");
		облШапка.Параметры.ПрибыльУбыток = ВыборкаОбщийИтог.ПрибыльУбыток;
		
		Если ВыборкаОбщийИтог.ПрибыльУбыток < 0 Тогда 
			облШапка.области.областьПрибыльУбытокШапка.цветФона = WebЦвета.Красный;
		Иначе
			облШапка.области.областьПрибыльУбытокШапка.цветФона = WebЦвета.ЗеленаяЛужайка					
		КонецЕсли;
		
		ТабДок.Вывести(облШапка);
		
		облСтрока = Макет.получитьОбласть("СтрокаГруппировка");
		облСтрокаПартия = Макет.получитьОбласть("СтрокаГруппировкаПартия");
		
		ТабДок.НачатьАвтогруппировкуСтрок();
		
		ВыборкаВалюта = ВыборкаОбщийИтог.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		
		Пока ВыборкаВалюта.Следующий() Цикл		
			облСтрока.Параметры.измерение = ВыборкаВалюта.Валюта.краткоеНаименование;
			облСтрока.Параметры.измерениеРасшифровка = Неопределено;
			облСтрока.Параметры.СуммаПродажи = ВыборкаВалюта.СуммаПродажи;
			облСтрока.Параметры.СуммаПродажиРуб =  ВыборкаВалюта.СуммаПродажиРуб;
			облСтрока.Параметры.ПрибыльУбыток =  ВыборкаВалюта.ПрибыльУбыток;
			облСтрока.Параметры.СуммаПокупкиВал =  ВыборкаВалюта.СуммаПокупкиВал;
			облСтрока.Параметры.СуммаПокупкиРуб =  ВыборкаВалюта.СуммаПокупкиРуб;
			
			Если ВыборкаВалюта.ПрибыльУбыток < 0 Тогда 
				облСтрока.области.областьПрибыльУбытокГруппировка.цветФона = WebЦвета.Красный;
			Иначе
				облСтрока.области.областьПрибыльУбытокГруппировка.цветФона = WebЦвета.ЗеленаяЛужайка					
			КонецЕсли;
			
			ТабДок.Вывести(облСтрока, 1);
			
			выборкаКошелек = ВыборкаВалюта.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
			
			Пока выборкаКошелек.Следующий() Цикл			
				облСтрока.Параметры.измерение = выборкаКошелек.кошелек;
				облСтрока.Параметры.измерениеРасшифровка = Неопределено;
				облСтрока.Параметры.СуммаПродажи = выборкаКошелек.СуммаПродажи;
				облСтрока.Параметры.СуммаПродажиРуб =  выборкаКошелек.СуммаПродажиРуб;
				облСтрока.Параметры.ПрибыльУбыток =  выборкаКошелек.ПрибыльУбыток;
				облСтрока.Параметры.СуммаПокупкиВал =  выборкаКошелек.СуммаПокупкиВал;
				облСтрока.Параметры.СуммаПокупкиРуб =  выборкаКошелек.СуммаПокупкиРуб;
				
				Если выборкаКошелек.ПрибыльУбыток < 0 Тогда 
					облСтрока.области.областьПрибыльУбытокГруппировка.цветФона = WebЦвета.Красный;
				Иначе
					облСтрока.области.областьПрибыльУбытокГруппировка.цветФона = WebЦвета.ЗеленаяЛужайка					
				КонецЕсли;
				
				ТабДок.Вывести(облСтрока, 2);
				
				выборкаРегистратор = выборкаКошелек.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
				
				Пока выборкаРегистратор.Следующий() Цикл			
					облСтрока.Параметры.измерение = формат(выборкаРегистратор.период, "ДФ=гггг.МММдд");
					облСтрока.Параметры.измерениеРасшифровка = выборкаРегистратор.Партия;
					облСтрока.Параметры.СуммаПродажи = выборкаРегистратор.СуммаПродажи;
					облСтрока.Параметры.СуммаПродажиРуб =  выборкаРегистратор.СуммаПродажиРуб;
					облСтрока.Параметры.ПрибыльУбыток =  выборкаРегистратор.ПрибыльУбыток;
					облСтрока.Параметры.СуммаПокупкиВал =  выборкаРегистратор.СуммаПокупкиВал;
					облСтрока.Параметры.СуммаПокупкиРуб =  выборкаРегистратор.СуммаПокупкиРуб;
					
					Если выборкаРегистратор.ПрибыльУбыток < 0 Тогда 
						облСтрока.области.областьПрибыльУбытокГруппировка.цветФона = WebЦвета.Красный;
					Иначе
						облСтрока.области.областьПрибыльУбытокГруппировка.цветФона = WebЦвета.ЗеленаяЛужайка					
					КонецЕсли;
					
					ТабДок.Вывести(облСтрока, 3);
					
					выборка = выборкаРегистратор.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
					
					Пока выборка.Следующий() Цикл				
						облСтрокаПартия.Параметры.измерение = выборка.ВалютаПредставление + " " + выборка.курсПокупки + " > " + Окр(выборка.курс, 2);
						облСтрокаПартия.Параметры.измерениеРасшифровка = выборка.регистратор;
						облСтрокаПартия.Параметры.СуммаПродажи = выборка.СуммаПродажи;
						облСтрокаПартия.Параметры.СуммаПродажиРуб =  выборка.СуммаПродажиРуб;
						облСтрокаПартия.Параметры.ПрибыльУбыток =  выборка.ПрибыльУбыток;
						облСтрокаПартия.Параметры.СуммаПокупкиВал =  выборка.СуммаПокупкиВал;
						облСтрокаПартия.Параметры.СуммаПокупкиРуб =  выборка.СуммаПокупкиРуб;
						
						Если выборка.ПрибыльУбыток < 0 Тогда 
							облСтрокаПартия.области.ОбластьПрибыльУбытокПартия.цветФона = WebЦвета.Красный;
						Иначе
							облСтрокаПартия.области.ОбластьПрибыльУбытокПартия.цветФона = WebЦвета.ЗеленаяЛужайка					
						КонецЕсли;
						
						ТабДок.Вывести(облСтрокаПартия, 4);
					КонецЦикла;
				КонецЦикла;
			КонецЦикла;
		КонецЦикла;
		
		ТабДок.ЗакончитьАвтогруппировкуСтрок();
		
		МассивШириныКолонок = Новый Массив;
		#Если МобильноеПриложениеСервер Тогда
			МассивШириныКолонок.Добавить(100);
			МассивШириныКолонок.Добавить(70);
			МассивШириныКолонок.Добавить(75);
			МассивШириныКолонок.Добавить(100);
		#Иначе
			МассивШириныКолонок.Добавить(100);
			МассивШириныКолонок.Добавить(90);
			МассивШириныКолонок.Добавить(100);
			МассивШириныКолонок.Добавить(100);
			
			Элементы.ТабДок.ОтображатьГруппировки = Истина;
		#КонецЕсли
		
		ОбщегоНазначения.РасчетШириныКолонок(ТабДок, МассивШириныКолонок);
	КонецЕсли;
	
	ОтчетСформирован = Истина;
КонецПроцедуры
