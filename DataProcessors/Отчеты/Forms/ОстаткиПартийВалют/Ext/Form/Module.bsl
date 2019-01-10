﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)	
	ПодготовитьФормуНаСервере();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура Настройки(Команда)
	структ = новый Структура;
	структ.Вставить("ОтборКошелек", ОтборКошелек);
	
	ОП = новый ОписаниеОповещения("НастройкаОтбораПослеИзменения", ЭтаФорма);
	
	ОткрытьФорму("Обработка.Отчеты.Форма.НастройкиОтбора", структ, , , , , ОП);
КонецПроцедуры

&НаКлиенте
Процедура НастройкаПорядка(Команда)
	структ = новый Структура;
	структ.Вставить("ПорядокИтогов", НастройкаПорядкаСерв());
	
	ОП = новый ОписаниеОповещения("НастройкаПорядкаПослеИзменения", ЭтаФорма);
	
	ОткрытьФорму("Обработка.Отчеты.Форма.НастройкиПорядка", структ, , , , , ОП);
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
	
	ДиаграммаОстатки.ОбластьПостроения.ЦветШкалы = WebЦвета.Черный;
КонецПроцедуры

&НаСервере
Процедура ПодготовитьФормуНаСервере()
	новСтр = ПорядокИтогов.Добавить();
	новСтр.поле = "Кошелек";
	новСтр.использовать = Истина;
	новСтр = ПорядокИтогов.Добавить();
	новСтр.поле = "Партия";
	новСтр.использовать = Истина;
	
	Периодичность = Перечисления.Периодичность.Неделя;
	
	период.ДатаНачала = НачалоДня(ТекущаяДата()) - 3600 * 24 * 365;
	Период.ДатаОкончания = КонецДня(ТекущаяДата());
	
	НастроитьОформлениеДиаграммы();
	ОбновитьТекущуюСтраницу();
КонецПроцедуры

&НаКлиенте
Процедура НастройкаОтбораПослеИзменения(Результат, допПараметры) Экспорт 
	Если Результат <> Неопределено Тогда 
		ОтборКошелек.ЗагрузитьЗначения(результат.отборКошелек.выгрузитьЗначения());
		
		ДиаграммаСформирована = ложь;			
		ОтчетСформирован = ложь;
		
		ОбновитьТекущуюСтраницу();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция НастройкаПорядкаСерв()
	Возврат ПоместитьВоВременноеХранилище(ПорядокИтогов.Выгрузить());
КонецФункции

&НаКлиенте
Процедура НастройкаПорядкаПослеИзменения(Результат, допПараметры) Экспорт 
	Если Результат <> Неопределено Тогда 
		НастройкаПорядкаПослеИзмененияСерв(результат, допПараметры);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура НастройкаПорядкаПослеИзмененияСерв(Результат, допПараметры) Экспорт 
	ПорядокИтогов.Загрузить(ПолучитьИзВременногоХранилища(Результат.ПорядокИтогов));
	
	ДиаграммаСформирована = ложь;			
	ОтчетСформирован = ложь;
	текУровеньГруппировки = -1;
	
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
		Если не ДиаграммаСформирована Тогда 
			//РеквизитФормыВЗначение("Объект").ОбновитьДиаграммуСервер(Кошелек, Период, Периодичность, ДиаграммаОстатки, Элементы,
			//ОтображатьВалютныеОстаткиВРублях, ДиаграммаСформирована);
		КонецЕсли;
	Иначе
		Если не ОтчетСформирован Тогда 
			ОбновитьОстаткиСерверСКД(Элементы);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ОбновитьОстаткиСервер(элементы) Экспорт 
	Запрос = Новый Запрос;
	МВТ = новый МенеджерВременныхТаблиц;
	запрос.МенеджерВременныхТаблиц = МВТ; 
	Запрос.УстановитьПараметр("Дата1", Период.ДатаНачала);
	Запрос.УстановитьПараметр("Дата2", период.ДатаОкончания);
	запрос.УстановитьПараметр("ВалютаУчета", Константы.ВалютаУчета.Получить());
	запрос.УстановитьПараметр("ОтборКошелек", ?(ОтборКошелек.Количество() = 0, Неопределено, ОтборКошелек));
	запрос.УстановитьПараметр("НеИспользоватьОтборКошелек", ОтборКошелек.Количество() = 0);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	КошелькиПартииОстатки.Валюта,
	|	КошелькиПартииОстатки.Кошелек,
	|	КошелькиПартииОстатки.Партия,
	|	КошелькиПартииОстатки.СуммаОстаток
	|ПОМЕСТИТЬ вт
	|ИЗ
	|	РегистрНакопления.КошелькиПартии.Остатки(
	|			,
	|			кошелек В (&отборКошелек)
	|				ИЛИ &неИспользоватьОтборКошелек) КАК КошелькиПартииОстатки
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
	|	вт.Партия,
	|	вт.СуммаОстаток КАК ОстатокВал,
	|	ЕСТЬNULL(КурсыВалютСрезПоследних.Курс, 1) КАК Курс,
	|	ЕСТЬNULL(КурсыВалютСрезПоследних.Курс, 1) * вт.СуммаОстаток КАК ОстатокРуб,
	|	вт.СуммаОстаток * (ЕСТЬNULL(КурсыВалютСрезПоследних.Курс, 1) - втПокупка.КурсПокупки) КАК ПрибыльУбыток,
	|	втПокупка.СуммаПокупкиРуб КАК СуммаПокупкиРуб,
	|	втПокупка.СуммаПокупки КАК СуммаПокупкиВал,
	|	втПокупка.КурсПокупки,
	|	ПРЕДСТАВЛЕНИЕ(вт.Валюта) КАК ВалютаПредставление,
	|	вт.Партия.Дата
	|ИЗ
	|	вт КАК вт
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КурсыВалют.СрезПоследних(
	|				,
	|				Валюта В
	|					(ВЫБРАТЬ
	|						вт.Валюта
	|					ИЗ
	|						вт)) КАК КурсыВалютСрезПоследних
	|		ПО вт.Валюта = КурсыВалютСрезПоследних.Валюта
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ втПокупка КАК втПокупка
	|		ПО вт.Валюта = втПокупка.Валюта
	|			И вт.Партия = втПокупка.Партия
	|
	|УПОРЯДОЧИТЬ ПО
	|	вт.Партия.Дата
	|ИТОГИ
	|	СУММА(ОстатокВал),
	|	СУММА(ОстатокРуб),
	|	СУММА(ПрибыльУбыток),
	|	СУММА(СуммаПокупкиРуб),
	|	СУММА(СуммаПокупкиВал)
	|ПО
	|	ОБЩИЕ,
	|	Валюта,
	|	Кошелек";
	
	результатЗапроса = запрос.Выполнить();
	ВыборкаОбщийИтог = результатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	ТабДок = новый ТабличныйДокумент;
	
	макет = РеквизитФормыВЗначение("Объект").ПолучитьМакет("МакетОстаткиПартииВалют");
	
	Если ВыборкаОбщийИтог.Следующий() Тогда 		
		облШапка = макет.получитьОбласть("Шапка");
		облШапка.параметры.ПрибыльУбыток = ВыборкаОбщийИтог.ПрибыльУбыток;
		
		Если ВыборкаОбщийИтог.ПрибыльУбыток < 0 Тогда 
			облШапка.области.областьПрибыльУбытокШапка.цветФона = WebЦвета.Красный;
		Иначе
			облШапка.области.областьПрибыльУбытокШапка.цветФона = WebЦвета.ЗеленаяЛужайка					
		КонецЕсли;
		
		ТабДок.Вывести(облШапка);
		
		облСтрока = макет.получитьОбласть("СтрокаГруппировка");
		облСтрокаПартия = макет.получитьОбласть("СтрокаГруппировкаПартия");
		
		ТабДок.НачатьАвтогруппировкуСтрок();
		
		ВыборкаВалюта = ВыборкаОбщийИтог.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		
		Пока ВыборкаВалюта.Следующий() Цикл		
			облСтрока.параметры.измерение = ВыборкаВалюта.Валюта.краткоеНаименование;
			облСтрока.параметры.ОстатокВал = ВыборкаВалюта.ОстатокВал;
			облСтрока.параметры.ОстатокРуб =  ВыборкаВалюта.ОстатокРуб;
			облСтрока.параметры.ПрибыльУбыток =  ВыборкаВалюта.ПрибыльУбыток;
			облСтрока.параметры.СуммаПокупкиВал =  ВыборкаВалюта.СуммаПокупкиВал;
			облСтрока.параметры.СуммаПокупкиРуб =  ВыборкаВалюта.СуммаПокупкиРуб;
			
			Если ВыборкаВалюта.ПрибыльУбыток < 0 Тогда 
				облСтрока.области.областьПрибыльУбытокГруппировка.цветФона = WebЦвета.Красный;
			Иначе
				облСтрока.области.областьПрибыльУбытокГруппировка.цветФона = WebЦвета.ЗеленаяЛужайка					
			КонецЕсли;
			
			ТабДок.Вывести(облСтрока, 1);
			
			выборкаКошелек = ВыборкаВалюта.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
			
			Пока выборкаКошелек.Следующий() Цикл			
				облСтрока.параметры.измерение = выборкаКошелек.кошелек;
				облСтрока.параметры.ОстатокВал = выборкаКошелек.ОстатокВал;
				облСтрока.параметры.ОстатокРуб = выборкаКошелек.ОстатокРуб;
				облСтрока.параметры.ПрибыльУбыток = выборкаКошелек.ПрибыльУбыток;
				облСтрока.параметры.СуммаПокупкиВал =  выборкаКошелек.СуммаПокупкиВал;
				облСтрока.параметры.СуммаПокупкиРуб =  выборкаКошелек.СуммаПокупкиРуб;
				
				Если выборкаКошелек.ПрибыльУбыток < 0 Тогда 
					облСтрока.области.областьПрибыльУбытокГруппировка.цветФона = WebЦвета.Красный;
				Иначе
					облСтрока.области.областьПрибыльУбытокГруппировка.цветФона = WebЦвета.ЗеленаяЛужайка					
				КонецЕсли;
				
				ТабДок.Вывести(облСтрока, 2);
				
				выборка = выборкаКошелек.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
				
				Пока выборка.Следующий() Цикл				
					облСтрокаПартия.параметры.измерение = выборка.ВалютаПредставление + " " + выборка.курсПокупки + " > " + Окр(выборка.курс, 2)
					+ " " + формат(выборка.партияДата, "ДФ=ддМММгг");
					облСтрокаПартия.параметры.измерениеРасшифровка = выборка.партия;
					облСтрокаПартия.параметры.ОстатокВал = выборка.ОстатокВал;
					облСтрокаПартия.параметры.ОстатокРуб = выборка.ОстатокРуб;
					облСтрокаПартия.параметры.ПрибыльУбыток = выборка.ПрибыльУбыток;
					облСтрокаПартия.параметры.ПрибыльУбытокРасшифровка = новый Структура("Партия", выборка.партия);
					
					облСтрокаПартия.параметры.СуммаПокупкиВал =  выборка.СуммаПокупкиВал;
					облСтрокаПартия.параметры.СуммаПокупкиРуб =  выборка.СуммаПокупкиРуб;
					
					Если выборка.ПрибыльУбыток < 0 Тогда 
						облСтрокаПартия.области.ОбластьПрибыльУбытокПартия.цветФона = WebЦвета.Красный;
					Иначе
						облСтрокаПартия.области.ОбластьПрибыльУбытокПартия.цветФона = WebЦвета.ЗеленаяЛужайка					
					КонецЕсли;
					
					ТабДок.Вывести(облСтрокаПартия, 3);
				КонецЦикла;
			КонецЦикла;
		КонецЦикла;
		
		ТабДок.ЗакончитьАвтогруппировкуСтрок();
		
		мас = новый Массив;
		#Если МобильноеПриложениеСервер Тогда
			мас.Добавить(100);
			мас.Добавить(55);
			мас.Добавить(75);
			мас.Добавить(100);
		#Иначе
			мас.Добавить(100);
			мас.Добавить(80);
			мас.Добавить(100);
			мас.Добавить(100);
			
			элементы.ТабДок.ОтображатьГруппировки = Истина;
		#КонецЕсли
		
		ОбщегоНазначения.РасчетШириныКолонок(ТабДок, мас);
	КонецЕсли;
	
	отчетСформирован = Истина;
КонецПроцедуры

&НаСервере
Процедура ОбновитьОстаткиСерверСКД(элементы)
	ТабДок.Очистить();
	
	//Получаем схему из макета
	СхемаКомпоновкиДанных = РеквизитФормыВЗначение("Объект").ПолучитьМакет("СКДОстаткиПартийВалют");
	
	//создадим компоновщик настроек и загрузим настройки по умолчанию, вместо настроек по умолчанию можно использовать восстановленные настройки
	КомпоновщикНастроек = Новый КомпоновщикНастроекКомпоновкиДанных();
	КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(СхемаКомпоновкиДанных));
	КомпоновщикНастроек.ЗагрузитьНастройки(СхемаКомпоновкиДанных.НастройкиПоУмолчанию);
	Настройки = КомпоновщикНастроек.Настройки;
	
	//установка параметров отчета, без КомпоновщикНастроекКомпоновкиДанных делать это гораздо сложнее
	Если ОтборКошелек.Количество() > 0 Тогда 
		Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("отборКошелек", ОтборКошелек);
	КонецЕсли;
	
	итогВалюта = Настройки.Структура.Получить(0);
	итогКошелек = итогВалюта.Структура.Получить(0);
	итогПартия = итогКошелек.Структура.Получить(0);		
	
	итогВалюта.Структура.Очистить();
	итогКошелек.Структура.Очистить();
	
	текИтог = итогВалюта;
	
	Для Каждого стр из ПорядокИтогов Цикл
		Если стр.Поле = "Кошелек" и стр.использовать = Истина Тогда 			
			новГруппировка = текИтог.Структура.Добавить(тип("ГруппировкаКомпоновкиДанных"));
			ЗаполнитьЗначенияСвойств(новГруппировка, итогКошелек);
			
			ОтчетыСКД.СкопироватьГруппировку(новГруппировка, итогКошелек);
			
			текИтог = новГруппировка;
		ИначеЕсли стр.Поле = "Партия" и стр.использовать = Истина Тогда 			
			новГруппировка = текИтог.Структура.Добавить(тип("ГруппировкаКомпоновкиДанных"));
			ЗаполнитьЗначенияСвойств(новГруппировка, итогПартия);
			
			ОтчетыСКД.СкопироватьГруппировку(новГруппировка, итогПартия);
			
			текИтог = новГруппировка;
		КонецЕсли;
	КонецЦикла;
	
	//Помещаем в переменную данные о расшифровке данных - здесь ненужный пункт, но пусть будет.
	ДанныеРасшифровки = Новый ДанныеРасшифровкиКомпоновкиДанных;
	
	//Формируем макет, с помощью компоновщика макета
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	
	//Передаем в макет компоновки схему, настройки и данные расшифровки
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, Настройки, ДанныеРасшифровки);
	
	//Выполним компоновку с помощью процессора компоновки
	ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновки, , ДанныеРасшифровки);
	
	//Очищаем поле табличного документа
	
	//Выводим результат в табличный документ
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ТабДок);
	
	ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных);
	
	АдресДанныхРасшифровки = ПоместитьВоВременноеХранилище(ДанныеРасшифровки, УникальныйИдентификатор);
	
	#Если МобильноеПриложениеСервер Тогда
	#Иначе		
		элементы.ТабДок.ОтображатьГруппировки = Истина;
	#КонецЕсли
	//Результат.ОтображатьЗаголовки = Ложь;
	//Результат.ОтображатьСетку = Ложь;
	//Результат.Показать();	
КонецПроцедуры

&НаКлиенте
Процедура ТабДокОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	
	Парам = ПолучитьПараметрыРасшифровкиДляОткрытияФормы(Расшифровка);
	
	Если Не СтандартнаяОбработка Тогда 
		ОткрытьФорму("Документ.Операция.ФормаСписка", Парам, ЭтаФорма);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция ПолучитьПараметрыРасшифровкиДляОткрытияФормы(Расшифровка)
	Парам = Новый Структура;
	
	СхемаКомпоновкиДанных = РеквизитФормыВЗначение("Объект").ПолучитьМакет("СКДОстаткиПартийВалютРасшифровка");
	
	ОтчетыСКД.ОбработкаРасшифровкиСервер(Расшифровка, Парам, АдресДанныхРасшифровки, СхемаКомпоновкиДанных);
	
	Возврат Парам;
КонецФункции

#КонецОбласти
