﻿#Область ПрограммныйИнтерфейс

// Возвращает курс валюты на дату
//
// Параметры:
//  Валюта     - Валюта (элемент справочника "Валюты")
//  ДатаКурса  - Дата, на которую следует получить курс
//
// Возвращаемое значение: 
//  Структура, содержащая:
//   Курс      - курс валюты
//   Кратность - кратность валюты
//
Функция ПолучитьКурсВалюты(Валюта, ДатаКурса = Неопределено, БазоваяВалюта = Неопределено) Экспорт
	
	//Если ДатаКурса = Неопределено Тогда
	//	ДатаКурса = ТекущаяДата();
	//КонецЕсли; 
	Если БазоваяВалюта = Неопределено Тогда
		БазоваяВалюта = Константы.ВалютаУчета.Получить();
	КонецЕсли; 
	Результат = РегистрыСведений.КурсыВалют.ПолучитьПоследнее(ДатаКурса, Новый Структура("Валюта,БазоваяВалюта", Валюта, БазоваяВалюта));
	
	Результат.Вставить("Валюта",    Валюта);
	Результат.Вставить("ДатаКурса", ДатаКурса);

	Возврат Результат;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Загрузка курсов валют из интернет

// Процедура Для загрузки курсов валют по определенному периоду.
//
// Параметры
// Валюты		- Любая коллекция - со следующими полями:
//					КодВалюты - числовой код валюты
//					Валюта - ссылка на валюту
// НачалоПериодаЗагрузки	- Дата - начало периода загрузки курсов
// ОкончаниеПериодаЗагрузки	- Дата - окончание периода загрузки курсов
//
// Возвращаемое значение:
// Массив состояния загрузки  - каждый элемент - структура с полями
//		Валюта - загружаемая Валюта
//		СтатусОперации - завершилась ли загрузка успешно
//		Сообщение - пояснение о загрузке (текст сообщения об ошибке Или поясняющее сообщение)
//
Функция ЗагрузитьКурсыВалютПоПараметрам(Знач Валюты, Знач НачалоПериодаЗагрузки, Знач ОкончаниеПериодаЗагрузки, 
						ПриЗагрузкеВозниклиОшибки = Ложь) Экспорт
	
	// Если Валюта учета - не рубли, надо загрузить курс валюты учета к рублю. 
	// Он нужен Для корректного пересчета курсов других валют после загрузки.
	ВалютаУчета = Константы.ВалютаУчета.Получить();
	ЗагрузитьКурсВалютыУчета = ВалютаУчета.Код <> "643";
	СписокЗагрузкиСодержитВалютуУчета = Ложь;
	Если ЗагрузитьКурсВалютыУчета Тогда
		Для Каждого Валюта Из Валюты Цикл
			Если Валюта.Валюта = ВалютаУчета Тогда
				СписокЗагрузкиСодержитВалютуУчета = Истина;
				Прервать;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	СостояниеЗагрузки = Новый Массив;
	
	ПриЗагрузкеВозниклиОшибки = Ложь;
	
	СерверИсточник = "cbrates.rbc.ru";
	
	Если НачалоПериодаЗагрузки = ОкончаниеПериодаЗагрузки Тогда
		Адрес = "tsv/";
		ТМП   = Формат(ОкончаниеПериодаЗагрузки, "ДФ=/yyyy/MM/dd"); // Не локализуется - путь к файлу на сервере
	Иначе
		Адрес = "tsv/cb/";
		ТМП   = "";
	КонецЕсли;
	
	Для Каждого Валюта Из Валюты Цикл
		
		Если Валюта.КодВалюты = "643" Тогда
			СостояниеЗагрузки.Добавить(Новый Структура("Валюта,СтатусОперации,Сообщение", Валюта.Валюта, Истина, ""));
			Продолжить; 
		КонецЕсли; 
		
		ФайлНаВебСервере = "http://" + СерверИсточник + "/" + Адрес + Прав(Валюта.КодВалюты, 3) + ТМП + ".tsv";
		
		Результат = ПолучениеФайловИзИнтернета.СкачатьФайлНаСервере(ФайлНаВебСервере);
		
		Если Результат <> Неопределено И Результат.Статус Тогда
			ПоясняющееСообщение = ЗагрузитьКурсВалютыИзФайла(Валюта.Валюта, Результат.Путь, НачалоПериодаЗагрузки, ОкончаниеПериодаЗагрузки) + Символы.ПС;
			УдалитьФайлы(Результат.Путь);
			СтатусОперации = Истина;
		Иначе
			ПоясняющееСообщение = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Невозможно получить файл данных с курсами валюты (%1 - %2):
				|%3
				|Возможно, нет доступа к веб сайту с курсами валют, либо указана несуществующая Валюта.'"),
				Валюта.КодВалюты,
				Валюта.Валюта,
				?(Результат = Неопределено, "причины не установлены", Результат.СообщениеОбОшибке));
			СтатусОперации = Ложь;
			ПриЗагрузкеВозниклиОшибки = Истина;
		КонецЕсли;
		
		СостояниеЗагрузки.Добавить(Новый Структура("Валюта,СтатусОперации,Сообщение", Валюта.Валюта, СтатусОперации, ПоясняющееСообщение));
		
	КонецЦикла;
	
	Если ЗагрузитьКурсВалютыУчета И НЕ СписокЗагрузкиСодержитВалютуУчета Тогда
		
		ФайлНаВебСервере = "http://" + СерверИсточник + "/" + Адрес + Прав(ВалютаУчета.Код, 3) + ТМП + ".tsv";
		
		Результат = ПолучениеФайловИзИнтернета.СкачатьФайлНаСервере(ФайлНаВебСервере);
		Если Результат.Статус Тогда
			ПоясняющееСообщение = ЗагрузитьКурсВалютыИзФайла(ВалютаУчета, Результат.Путь, НачалоПериодаЗагрузки, ОкончаниеПериодаЗагрузки) + Символы.ПС;
			УдалитьФайлы(Результат.Путь);
			СтатусОперации = Истина;
		Иначе
			ПоясняющееСообщение = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Не удалось загрузить курс валюты учета (%1 - %2) к российскому рублю.
						   |Курсы других валют могут быть рассчитаны неверно.
						   |Возможно, нет доступа к веб сайту с курсами валют, либо указана несуществующая Валюта.
						   |Текст ошибки:
						   |%3'"),
				ВалютаУчета.Код,
				ВалютаУчета.Ссылка,
				Результат.СообщениеОбОшибке);
			Сообщить(ПоясняющееСообщение);
			// Не Показываем ошибки при загрузке курса валюты учета.
			// Если они возникли, значит Для этой валюты нет курсов на РБК.
		КонецЕсли;
		
	КонецЕсли;
	
	ПересчитатьЗагруженныеКурсыВалют(СостояниеЗагрузки, Неопределено, НачалоПериодаЗагрузки, ОкончаниеПериодаЗагрузки);
	
	Возврат СостояниеЗагрузки;
	
КонецФункции

// Загружает информацию о курсе валюты Валюта из файла ПутьКФайлу в регистр
// сведений курсов валют. При этом файл с курсами разбирается, и записываются
// только те данные, которые удовлетворяют периоду (НачалоПериодаЗагрузки, ОкончаниеПериодаЗагрузки).
//
Функция ЗагрузитьКурсВалютыИзФайла(Знач Валюта, Знач ПутьКФайлу, Знач НачалоПериодаЗагрузки, Знач ОкончаниеПериодаЗагрузки) Экспорт
	
	СтатусЗагрузки = 1;
	
	ЧислоЗагружаемыхДнейВсего = 1 + (ОкончаниеПериодаЗагрузки - НачалоПериодаЗагрузки) / ( 24 * 60 * 60);
	
	ЧислоЗагруженныхДней = 0;
	
	ВалютаУчета = Константы.ВалютаУчета.Получить();
	
	// Пока единственным источником курсов является РБК, курсы всех валют загружаются в рублях
	БазоваяВалютаФайла = Справочники.Валюты.НайтиПоКоду("643");
	Если НЕ ЗначениеЗаполнено(БазоваяВалютаФайла) Тогда
		БазоваяВалютаФайла = ВалютаУчета;
	КонецЕсли; 
	
	Если ЭтоАдресВременногоХранилища(ПутьКФайлу) Тогда
		ИмяФайла = ПолучитьИмяВременногоФайла();
		ДвоичныеДанные = ПолучитьИзВременногоХранилища(ПутьКФайлу);
		ДвоичныеДанные.Записать(ИмяФайла);
	Иначе
		ИмяФайла = ПутьКФайлу;
	КонецЕсли;
	
	ЧтениеТекста = Новый ЧтениеТекста(ИмяФайла, КодировкаТекста.ANSI);
	//Текст = Новый ТекстовыйДокумент();
	
	РегистрКурсыВалют = РегистрыСведений.КурсыВалют;
	
	//Текст.Прочитать(ИмяФайла, КодировкаТекста.ANSI);
	//КолСтрок = Текст.КоличествоСтрок();
	
	Стр = "";
	
	Пока Стр <> Неопределено Цикл
		
		Стр = ЧтениеТекста.ПрочитатьСтроку();
		
		Если (Стр = "") Или (Найти(Стр,Символы.Таб) = 0) Тогда
			Продолжить;
		КонецЕсли;
		
		Если НачалоПериодаЗагрузки = ОкончаниеПериодаЗагрузки Тогда
			ДатаКурса = ОкончаниеПериодаЗагрузки;
		Иначе
			ДатаКурсаСтр = ВыделитьПодстроку(Стр);
			ДатаКурса    = Дата(Лев(ДатаКурсаСтр,4), Сред(ДатаКурсаСтр,5,2), Сред(ДатаКурсаСтр,7,2));
		КонецЕсли;
		
		Кратность = Число(ВыделитьПодстроку(Стр));
		Курс      = Число(ВыделитьПодстроку(Стр));
		
		Если ДатаКурса > ОкончаниеПериодаЗагрузки Тогда
			Прервать;
		КонецЕсли;
		
		Если ДатаКурса < НачалоПериодаЗагрузки Тогда 
			Продолжить;
		КонецЕсли;
		
		ЗаписьКурсовВалют = РегистрКурсыВалют.СоздатьМенеджерЗаписи();
		
		ЗаписьКурсовВалют.Валюта    = Валюта;
		ЗаписьКурсовВалют.БазоваяВалюта = БазоваяВалютаФайла;
		ЗаписьКурсовВалют.Период    = ДатаКурса;
		ЗаписьКурсовВалют.Курс      = Курс;
		ЗаписьКурсовВалют.Кратность = Кратность;
		ЗаписьКурсовВалют.Записать();
		
		ЧислоЗагруженныхДней = ЧислоЗагруженныхДней + 1;
		
	КонецЦикла;
	
	Если ЭтоАдресВременногоХранилища(ПутьКФайлу) Тогда
		УдалитьФайлы(ИмяФайла);
		УдалитьИзВременногоХранилища(ПутьКФайлу);
	КонецЕсли;
	
	Если ЧислоЗагружаемыхДнейВсего = ЧислоЗагруженныхДней Тогда
		ПояснениеОЗагрузке = "";
	ИначеЕсли ЧислоЗагруженныхДней = 0 Тогда
		ПояснениеОЗагрузке = НСтр("ru = 'Курсы валюты %1 - %2 не загружены. Нет данных.'");
	Иначе
		ПояснениеОЗагрузке = НСтр("ru = 'Загружены не все курсы по валюте %1 - %2.'");
	КонецЕсли;
	
	ПояснениеОЗагрузке = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
									ПояснениеОЗагрузке,
									Валюта.Код,
									Валюта.Наименование);
	
	Возврат ПояснениеОЗагрузке;
	
КонецФункции

// Выбирает за период все курсы валют, выраженные в БазовойВалютеРБК, и добавляет курсы, пересчитанные в валюту учета.
// В качестве БазовойВалютыРБК может быть указана другая Валюта, при условии, что существуют курсы всех валют 
// из МассивСтруктурЗагруженныхВалют, выраженные в этой валюте.
//
Процедура ПересчитатьЗагруженныеКурсыВалют(Знач МассивСтруктурЗагруженныхВалют, Знач БазоваяВалютаРБК, Знач НачалоПериодаЗагрузки, Знач ОкончаниеПериодаЗагрузки) Экспорт

	ВалютаУчета = Константы.ВалютаУчета.Получить();
	Если БазоваяВалютаРБК = Неопределено Тогда
		БазоваяВалютаРБК = Справочники.Валюты.НайтиПоКоду("643");
		Если НЕ ЗначениеЗаполнено(БазоваяВалютаРБК) Тогда
			// Невозможно пересчитать курсы, т.к. БазоваяВалютаРБК отсутствует
			Возврат;
		КонецЕсли; 
	КонецЕсли; 
	
	Если ВалютаУчета = БазоваяВалютаРБК Тогда
		// Валюта учета соответствует валюте, в которой загружались курсы
		Возврат;
	КонецЕсли; 

	// Убедимся, что Для базовой валюты установлен курс 1
	ПроверитьКорректностьКурсаНа01_01_1980(ВалютаУчета, ВалютаУчета);
	
	// Определим, по каким именно Валютам были загружены новые курсы:
	ВалютыДляПересчета = Новый Массив;
	Для Каждого ЭлементЗагрузки Из МассивСтруктурЗагруженныхВалют Цикл
		Если ЗначениеЗаполнено(ЭлементЗагрузки.Валюта) И ЭлементЗагрузки.СтатусОперации = Истина Тогда
			ВалютыДляПересчета.Добавить(ЭлементЗагрузки.Валюта);
		КонецЕсли; 
	КонецЦикла; 
	
	Если ВалютыДляПересчета.Количество() = 0 Тогда
		// Нет ни одной удачно загруженной валюты
		Возврат;
	КонецЕсли; 
	
	// Очистим значения новой базовой валюты к самой себе
	НаборЗаписей = РегистрыСведений.КурсыВалют.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.БазоваяВалюта.Установить(ВалютаУчета);
	НаборЗаписей.Отбор.Валюта.Установить(ВалютаУчета);
	НаборЗаписей.Записать(Истина);
	
	// Зададим Для новой базовой валюты курс равный 1
	ЗаписьКурсовВалют = РегистрыСведений.КурсыВалют.СоздатьМенеджерЗаписи();
	ЗаписьКурсовВалют.Период        = '19800101';
	ЗаписьКурсовВалют.БазоваяВалюта = ВалютаУчета;
	ЗаписьКурсовВалют.Валюта        = ВалютаУчета;
	ЗаписьКурсовВалют.Курс          = 1;
	ЗаписьКурсовВалют.Кратность     = 1;
	ЗаписьКурсовВалют.Записать(Истина);
	
	// Курсы валют пересчитываем из валюты, в которой они были загружены, в валюту учета.
	// Исходные курсы оставляем, как есть. Добавляем новые курсы.
	
	// Выбираем за период все курсы валют в БазовойВалютеРБК и добавляем курсы, пересчитанные в ВалютуУчета 
	Отбор = Новый Структура("БазоваяВалюта", БазоваяВалютаРБК);
	Выборка = РегистрыСведений.КурсыВалют.Выбрать(НачалоПериодаЗагрузки, ОкончаниеПериодаЗагрузки, Отбор);
	Пока Выборка.Следующий() Цикл
		Если ВалютыДляПересчета.Найти(Выборка.Валюта) = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		Если Выборка.Валюта = Выборка.БазоваяВалюта Тогда
			Продолжить;
		КонецЕсли;
		
		СоздатьЗаписьКурсаВалютыСПересчетомВНовуюБазовуюВалюту(Выборка, БазоваяВалютаРБК, ВалютаУчета);
		
	КонецЦикла;
	
	// Проверим курсы на НачалоПериодаЗагрузки
	Для Каждого Валюта Из ВалютыДляПересчета Цикл
		
		Отбор = Новый Структура("Валюта, БазоваяВалюта", Валюта, БазоваяВалютаРБК);
		ЗаписиКурсаВалюты = РегистрыСведений.КурсыВалют.СрезПоследних(НачалоПериодаЗагрузки, Отбор);
		Если ЗаписиКурсаВалюты.Количество() = 1 Тогда
			Если ЗаписиКурсаВалюты[0].Валюта = ЗаписиКурсаВалюты[0].БазоваяВалюта Тогда
				Продолжить;
			КонецЕсли;
			
			Если ЗаписиКурсаВалюты[0].Период <> НачалоПериодаЗагрузки Тогда
				ЗаписиКурсаВалюты[0].Период = НачалоПериодаЗагрузки;
				СоздатьЗаписьКурсаВалютыСПересчетомВНовуюБазовуюВалюту(ЗаписиКурсаВалюты[0], БазоваяВалютаРБК, ВалютаУчета);
			КонецЕсли;
			
		ИначеЕсли ЗаписиКурсаВалюты.Количество() = 0 Тогда
			// Невозможно рассчитать курс
			Возврат;
			
		Иначе
			ВызватьИсключение НСтр("ru = 'Неверные данные в регистре сведений.'"); 
			
		КонецЕсли;
		
	КонецЦикла;
	
	// Рассчитаем курсы Для БазовойВалютыРБК.
	Если ВалютыДляПересчета.Найти(БазоваяВалютаРБК) <> Неопределено Тогда
		
		// Курс БазовойВалютыРБК равен обратному курсу ВалютыУчета
		Отбор = Новый Структура("Валюта", ВалютаУчета);
		Выборка = РегистрыСведений.КурсыВалют.Выбрать(НачалоПериодаЗагрузки, ОкончаниеПериодаЗагрузки, Отбор);
		Пока Выборка.Следующий() Цикл
			Если Выборка.БазоваяВалюта = БазоваяВалютаРБК Тогда
				СоздатьОбратнуюЗаписьКурсаВалюты(Выборка);
			КонецЕсли;
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

// Проверяет наличие установленного курса и кратности валюты на 1 января 1980 года.
// В случае отсутствия устанавливает курс и кратность равными единице.
//
// Параметры:
//  Валюта - ссылка на элемент справочника Валют
//
Процедура ПроверитьКорректностьКурсаНа01_01_1980(Валюта, ВалютаУчета) Экспорт

	Если НЕ ЗначениеЗаполнено(ВалютаУчета) Тогда
		Возврат;
	КонецЕсли;
	
	ДатаКурса = Дата("19800101");
	СтруктураКурса = РегистрыСведений.КурсыВалют.ПолучитьПоследнее(ДатаКурса, Новый Структура("Валюта, БазоваяВалюта", Валюта, ВалютаУчета));
	
	Если (СтруктураКурса.Курс = 0) Или (СтруктураКурса.Кратность = 0) Тогда
		
		РегистрКурсыВалют = РегистрыСведений.КурсыВалют.СоздатьМенеджерЗаписи();
		
		РегистрКурсыВалют.Период    = ДатаКурса;
		РегистрКурсыВалют.Валюта    = Валюта;
		РегистрКурсыВалют.БазоваяВалюта = ВалютаУчета;
		РегистрКурсыВалют.Курс      = 1;
		РегистрКурсыВалют.Кратность = 1;
		РегистрКурсыВалют.Записать();
	КонецЕсли;
	
КонецПроцедуры // ПроверитьКорректностьКурсаНа01_01_1980()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Выделяет из переданной строки первое значение
//  до символа "TAB"
//
// Параметры: 
//  ИсходнаяСтрока - Строка - строка Для разбора
//
// Возвращаемое значение:
//  подстроку до символа "TAB"
//
Функция ВыделитьПодстроку(ИсходнаяСтрока)
	
	Перем ПодСтрока;
	
	Поз = Найти(ИсходнаяСтрока,Символы.Таб);
	Если Поз > 0 Тогда
		ПодСтрока = Лев(ИсходнаяСтрока,Поз-1);
		ИсходнаяСтрока = Сред(ИсходнаяСтрока,Поз + 1);
	Иначе
		ПодСтрока = ИсходнаяСтрока;
		ИсходнаяСтрока = "";
	КонецЕсли;
	
	Возврат ПодСтрока;
	
КонецФункции

// Рассчитывает обратный курс и записывает в регистр сведений, меняя местами измерения Валюта и БазоваяВалюта.
//
// Параметры:
//   ИсходнаяЗапись  - Произвольный - любая коллекция, Для которой надо создать обратную запись, с полями:
//       * Валюта    - СправочникСсылка.Валюты - Ссылка пересчитываемой валюты.
//       * БазоваяВалюта - СправочникСсылка.Валюты - Ссылка базовой валюты валюты.
//       * Курс      - Число - Курс пересчитываемой валюты.
//       * Кратность - Число - Кратность пересчитываемой валюты.
//   БазоваяВалютаРБК   - СправочникСсылка.Валюты - ссылка на валюту "Российский рубль" (Валюта, Для которой рассчитаны курсы, загруженные с РБК).
//   НоваяБазоваяВалюта - СправочникСсылка.Валюты - Валюта, по отношению к которой рассчитывается Новый курс.
//
Процедура СоздатьОбратнуюЗаписьКурсаВалюты(ИсходнаяЗапись)
	
	НовыйКурс = ИсходнаяЗапись.Кратность / ?(ИсходнаяЗапись.Курс <> 0, ИсходнаяЗапись.Курс, 1);
	НоваяКратность = 1;
	
	НоваяЗапись = РегистрыСведений.КурсыВалют.СоздатьМенеджерЗаписи();
	НоваяЗапись.Период        = ИсходнаяЗапись.Период;
	НоваяЗапись.БазоваяВалюта = ИсходнаяЗапись.Валюта;
	НоваяЗапись.Валюта        = ИсходнаяЗапись.БазоваяВалюта;
	НоваяЗапись.Курс          = НовыйКурс;
	НоваяЗапись.Кратность     = НоваяКратность;
	НоваяЗапись.Записать(Истина);
	
КонецПроцедуры

// По курсу, загруженному с РБК, рассчитывает курс к НовойБазовойВалюте и записывает в регистр сведений.
//
// Параметры:
//   ПараметрыКурсаРБК  - Произвольный - любая коллекция с полями:
//       * Валюта    - СправочникСсылка.Валюты - Ссылка пересчитываемой валюты.
//       * Курс      - Число - Курс пересчитываемой валюты.
//       * Кратность - Число - Кратность пересчитываемой валюты.
//   БазоваяВалютаРБК   - СправочникСсылка.Валюты - ссылка на валюту "Российский рубль" (Валюта, Для которой рассчитаны курсы, загруженные с РБК).
//   НоваяБазоваяВалюта - СправочникСсылка.Валюты - Валюта, по отношению к которой рассчитывается Новый курс.
//
Процедура СоздатьЗаписьКурсаВалютыСПересчетомВНовуюБазовуюВалюту(ПараметрыКурсаРБК, БазоваяВалютаРБК, НоваяБазоваяВалюта)

	//Если БазоваяВалютаРБК = Неопределено Или БазоваяВалютаРБК.Код <> "643" Тогда
	Если БазоваяВалютаРБК = Неопределено Тогда
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Неверный параметр %1.'"), "БазоваяВалютаРБК");
	КонецЕсли; 
	
	Если НоваяБазоваяВалюта = БазоваяВалютаРБК Тогда
		// Новая базовая Валюта соответствует валюте, в которой загружались курсы
		Возврат;
	КонецЕсли; 
	
	Если ПараметрыКурсаРБК.Валюта = НоваяБазоваяВалюта Тогда
		// Курс валюты к самой себе всегда 1
		Возврат;
	КонецЕсли; 
	
	// Определим курс НовойБазовойВалюты, выраженный в БазовойВалютеРБК
	Отбор = Новый Структура("Валюта, БазоваяВалюта", НоваяБазоваяВалюта, БазоваяВалютаРБК);
	ЗаписиКурсаВалюты = РегистрыСведений.КурсыВалют.СрезПоследних(ПараметрыКурсаРБК.Период, Отбор);
	Если ЗаписиКурсаВалюты.Количество() = 1 Тогда
		КурсНовойБазовойВалюты = ЗаписиКурсаВалюты[0].Курс;
		Если КурсНовойБазовойВалюты = Null Тогда
			КурсНовойБазовойВалюты = 0;
		КонецЕсли;
		КратностьНовойБазовойВалюты = ЗаписиКурсаВалюты[0].Кратность;
		Если КратностьНовойБазовойВалюты = Null Тогда
			КратностьНовойБазовойВалюты = 0;
		КонецЕсли;
		
	ИначеЕсли ЗаписиКурсаВалюты.Количество() = 0 Тогда
		// Невозможно рассчитать курс
		Возврат;
		
	Иначе
		ВызватьИсключение НСтр("ru = 'Неверные данные в регистре сведений.'"); 
		
	КонецЕсли;
	
	НовыйКурс = (ПараметрыКурсаРБК.Курс * КратностьНовойБазовойВалюты) 
		/ (?(КурсНовойБазовойВалюты <> 0, КурсНовойБазовойВалюты, 1) 
		   * ?(ПараметрыКурсаРБК.Кратность <> 0, ПараметрыКурсаРБК.Кратность, 1));
	НоваяКратность = 1;
	
	// Запишем рассчитанный курс
	НоваяЗапись = РегистрыСведений.КурсыВалют.СоздатьМенеджерЗаписи();
	НоваяЗапись.Период        = ПараметрыКурсаРБК.Период;
	НоваяЗапись.БазоваяВалюта = НоваяБазоваяВалюта;
	НоваяЗапись.Валюта        = ПараметрыКурсаРБК.Валюта;
	НоваяЗапись.Курс          = НовыйКурс;
	НоваяЗапись.Кратность     = НоваяКратность;
	НоваяЗапись.Записать(Истина);
	
КонецПроцедуры

#КонецОбласти