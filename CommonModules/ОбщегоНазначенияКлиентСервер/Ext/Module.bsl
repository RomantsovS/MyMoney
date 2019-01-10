﻿#Область ПрограммныйИнтерфейс

// Разбирает строку URI на составные части и возвращает в виде структуры.
// На основе RFC 3986.
//
// Параметры:
//     СтрокаURI - Строка - ссылка на ресурс в формате: <схема>://<логин>:<пароль>@<хост>:<порт>/<путь>?<параметры>#<якорь>
//
// Возвращаемое значение:
//     Структура - составные части URI согласно формату:
//         * Схема         - Строка
//         * Логин         - Строка
//         * Пароль        - Строка
//         * ИмяСервера    - Строка - часть <хост>:<порт> входного параметра
//         * Хост          - Строка
//         * Порт          - Строка
//         * ПутьНаСервере - Строка - часть <путь>?<параметры>#<якорь> входного параметра
//
Функция СтруктураURI(Знач СтрокаURI) Экспорт
	
	СтрокаURI = СокрЛП(СтрокаURI);
	
	// схема
	Схема = "";
	Позиция = Найти(СтрокаURI, "://");
	Если Позиция > 0 Тогда
		Схема = НРег(Лев(СтрокаURI, Позиция - 1));
		СтрокаURI = Сред(СтрокаURI, Позиция + 3);
	КонецЕсли;

	// строка соединения и путь на сервере
	СтрокаСоединения = СтрокаURI;
	ПутьНаСервере = "";
	Позиция = Найти(СтрокаСоединения, "/");
	Если Позиция > 0 Тогда
		ПутьНаСервере = Сред(СтрокаСоединения, Позиция + 1);
		СтрокаСоединения = Лев(СтрокаСоединения, Позиция - 1);
	КонецЕсли;
		
	// информация пользователя и имя сервера
	СтрокаАвторизации = "";
	ИмяСервера = СтрокаСоединения;
	Позиция = Найти(СтрокаСоединения, "@");
	Если Позиция > 0 Тогда
		СтрокаАвторизации = Лев(СтрокаСоединения, Позиция - 1);
		ИмяСервера = Сред(СтрокаСоединения, Позиция + 1);
	КонецЕсли;
	
	// логин и пароль
	Логин = СтрокаАвторизации;
	Пароль = "";
	Позиция = Найти(СтрокаАвторизации, ":");
	Если Позиция > 0 Тогда
		Логин = Лев(СтрокаАвторизации, Позиция - 1);
		Пароль = Сред(СтрокаАвторизации, Позиция + 1);
	КонецЕсли;
	
	// хост и порт
	Хост = ИмяСервера;
	Порт = "";
	Позиция = Найти(ИмяСервера, ":");
	Если Позиция > 0 Тогда
		Хост = Лев(ИмяСервера, Позиция - 1);
		Порт = Сред(ИмяСервера, Позиция + 1);
	КонецЕсли;
	
	Результат = Новый Структура;
	Результат.Вставить("Схема", Схема);
	Результат.Вставить("Логин", Логин);
	Результат.Вставить("Пароль", Пароль);
	Результат.Вставить("ИмяСервера", ИмяСервера);
	Результат.Вставить("Хост", Хост);
	Результат.Вставить("Порт", ?(ПустаяСтрока(Порт), Неопределено, Число(Порт)));
	Результат.Вставить("ПутьНаСервере", ПутьНаСервере);
	
	Возврат Результат;
	
КонецФункции

Функция ОтносительнаяДатаСинхронизации(Знач ДатаСинхронизации) Экспорт
	
	Если Не ЗначениеЗаполнено(ДатаСинхронизации) Тогда
		
		Возврат НСтр("ru = 'Никогда'");
		
	КонецЕсли;
	
	ДатаТекущая = ТекущаяДата();
	
	Интервал = ДатаТекущая - ДатаСинхронизации;
	
	Если Интервал < 0 Тогда // 0 мин
		
		Результат = Формат(ДатаСинхронизации, "ДЛФ=DD");
		
	ИначеЕсли Интервал < 60 * 5 Тогда // 5 мин
		
		Результат = НСтр("ru = 'Сейчас'");
		
	ИначеЕсли Интервал < 60 * 15 Тогда // 15 мин
		
		Результат = НСтр("ru = '5 минут назад'");
		
	ИначеЕсли Интервал < 60 * 30 Тогда // 30 мин
		
		Результат = НСтр("ru = '15 минут назад'");
		
	ИначеЕсли Интервал < 60 * 60 * 1 Тогда // 1 час
		
		Результат = НСтр("ru = '30 минут назад'");
		
	ИначеЕсли Интервал < 60 * 60 * 2 Тогда // 2 часа
		
		Результат = НСтр("ru = '1 час назад'");
		
	ИначеЕсли Интервал < 60 * 60 * 3 Тогда // 3 часа
		
		Результат = НСтр("ru = '2 часа назад'");
		
	Иначе
		
		КоличествоДнейРазницы = КоличествоДнейРазницы(ДатаСинхронизации, ДатаТекущая);
		
		Если КоличествоДнейРазницы = 0 Тогда // сегодня
			
			Результат = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Сегодня, %1'"), Формат(ДатаСинхронизации, "ДЛФ=T"));
			
		ИначеЕсли КоличествоДнейРазницы = 1 Тогда // вчера
			
			Результат = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Вчера, %1'"), Формат(ДатаСинхронизации, "ДЛФ=T"));
			
		ИначеЕсли КоличествоДнейРазницы = 2 Тогда // позавчера
			
			Результат = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Позавчера, %1'"), Формат(ДатаСинхронизации, "ДЛФ=T"));
			
		Иначе // давно
			
			Результат = Формат(ДатаСинхронизации, "ДЛФ=DD");
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Результат;
КонецФункции

Функция КоличествоДнейРазницы(Знач Дата1, Знач Дата2)
	
	Возврат Цел((НачалоДня(Дата2) - НачалоДня(Дата1)) / 86400);
	
КонецФункции

// Формирует и выводит сообщение, которое может быть связано с элементом 
// управления формы.
//
// Параметры:
//  ТекстСообщенияПользователю - Строка - текст сообщения.
//  КлючДанных                 - ЛюбаяСсылка - объект или ключ записи информационной базы, к которому это сообщение относится.
//  Поле                       - Строка - наименование реквизита формы.
//  ПутьКДанным                - Строка - путь к данным (путь к реквизиту формы).
//  Отказ                      - Булево - выходной параметр, всегда устанавливается в значение Истина.
//
// Пример:
//
//  1. Для вывода сообщения у поля управляемой формы, связанного с реквизитом объекта:
//  ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
//   НСтр("ru = 'Сообщение об ошибке.'"), ,
//   "ПолеВРеквизитеФормыОбъект",
//   "Объект");
//
//  Альтернативный вариант использования в форме объекта:
//  ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
//   НСтр("ru = 'Сообщение об ошибке.'"), ,
//   "Объект.ПолеВРеквизитеФормыОбъект");
//
//  2. Для вывода сообщения рядом с полем управляемой формы, связанным с реквизитом формы:
//  ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
//   НСтр("ru = 'Сообщение об ошибке.'"), ,
//   "ИмяРеквизитаФормы");
//
//  3. Для вывода сообщения связанного с объектом информационной базы:
//  ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
//   НСтр("ru = 'Сообщение об ошибке.'"), ОбъектИнформационнойБазы, "Ответственный",,Отказ);
//
//  4. Для вывода сообщения по ссылке на объект информационной базы:
//  ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
//   НСтр("ru = 'Сообщение об ошибке.'"), Ссылка, , , Отказ);
//
//  Случаи некорректного использования:
//   1. Передача одновременно параметров КлючДанных и ПутьКДанным.
//   2. Передача в параметре КлючДанных значения типа отличного от допустимых.
//   3. Установка ссылки без установки поля (и/или пути к данным).
//
Процедура СообщитьПользователю(
		Знач ТекстСообщенияПользователю,
		Знач КлючДанных = Неопределено,
		Знач Поле = "",
		Знач ПутьКДанным = "",
		Отказ = Ложь) Экспорт
	
	Сообщение = Новый СообщениеПользователю;
	Сообщение.Текст = ТекстСообщенияПользователю;
	Сообщение.Поле = Поле;
	
	ЭтоОбъект = Ложь;
	
#Если НЕ ТонкийКлиент И НЕ ВебКлиент Тогда
	Если КлючДанных <> Неопределено
	   И XMLТипЗнч(КлючДанных) <> Неопределено Тогда
		ТипЗначенияСтрокой = XMLТипЗнч(КлючДанных).ИмяТипа;
		ЭтоОбъект = СтрНайти(ТипЗначенияСтрокой, "Object.") > 0;
	КонецЕсли;
#КонецЕсли
	
	Если ЭтоОбъект Тогда
		Сообщение.УстановитьДанные(КлючДанных);
	Иначе
		Сообщение.КлючДанных = КлючДанных;
	КонецЕсли;
	
	Если НЕ ПустаяСтрока(ПутьКДанным) Тогда
		Сообщение.ПутьКДанным = ПутьКДанным;
	КонецЕсли;
		
	Сообщение.Сообщить();
	
	Отказ = Истина;
	
КонецПроцедуры

Функция ЕстьРеквизитОбъекта(Объект, ИмяРеквизита) Экспорт
	
	КлючУникальности   = Новый УникальныйИдентификатор;
	СтруктураРеквизита = Новый Структура(ИмяРеквизита, КлючУникальности);

	ЗаполнитьЗначенияСвойств(СтруктураРеквизита, Объект);
	
	Возврат СтруктураРеквизита[ИмяРеквизита] <> КлючУникальности;
	
КонецФункции

Функция ПолучитьXML(Значение) Экспорт
	
	Запись = Новый ЗаписьXML();
	Запись.УстановитьСтроку();
	СериализаторXDTO.ЗаписатьXML(Запись, Значение);
	Возврат Запись.Закрыть();
	
КонецФункции

// Возвращает Истина, если включен режим отладки.
//
// Возвращаемое значение:
//  Булево - Истина, если включен режим отладки.
Функция РежимОтладки() Экспорт
	
	Возврат Ложь;
	
КонецФункции

// Вызывает исключение с текстом Сообщение, если Условие не равно Истина.
// Применяется для самодиагностики кода.
//
// Параметры:
//   Условие                - Булево - если не равно Истина, то вызывается исключение.
//   КонтекстПроверки       - Строка - например, имя процедуры или функции, в которой выполняется проверка.
//   Сообщение              - Строка - текст сообщения. Если не задан, то исключение вызывается с сообщением по
//                                     умолчанию.
//
Процедура Проверить(Знач Условие, Знач Сообщение = "", Знач КонтекстПроверки = "") Экспорт
	
	Если Условие <> Истина Тогда
		Если ПустаяСтрока(Сообщение) Тогда
			ТекстИсключения = НСтр("ru = 'Недопустимая операция'"); // Assertion failed
		Иначе
			ТекстИсключения = Сообщение;
		КонецЕсли;
		Если Не ПустаяСтрока(КонтекстПроверки) Тогда
			ТекстИсключения = ТекстИсключения + " " + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'в %1'"), КонтекстПроверки);
		КонецЕсли;
		ВызватьИсключение ТекстИсключения;
	КонецЕсли;
	
КонецПроцедуры

// Вызывает исключение, если тип значения параметра ИмяПараметра процедуры или функции ИмяПроцедурыИлиФункции
// отличается от ожидаемого.
// Для диагностики типов параметров, передаваемых в процедуры и функции программного интерфейса.
//
// Параметры:
//   ИмяПроцедурыИлиФункции - Строка             - имя процедуры или функции, параметр которой проверяется.
//   ИмяПараметра           - Строка             - имя проверяемого параметра процедуры или функции.
//   ЗначениеПараметра      - Произвольный       - фактическое значение параметра.
//   ОжидаемыеТипы  - ОписаниеТипов, Тип, Массив - тип(ы) параметра процедуры или функции.
//   ОжидаемыеТипыСвойств   - Структура          - если ожидаемый тип - структура, то 
//                                                 в этом параметре можно указать типы ее свойств.
//
Процедура ПроверитьПараметр(Знач ИмяПроцедурыИлиФункции, Знач ИмяПараметра, Знач ЗначениеПараметра, 
	Знач ОжидаемыеТипы, Знач ОжидаемыеТипыСвойств = Неопределено) Экспорт
	
	Контекст = "ОбщегоНазначенияКлиентСервер.ПроверитьПараметр";
	Проверить(ТипЗнч(ИмяПроцедурыИлиФункции) = Тип("Строка"), 
		НСтр("ru = 'Недопустимо значение параметра ИмяПроцедурыИлиФункции'"), Контекст);
	Проверить(ТипЗнч(ИмяПараметра) = Тип("Строка"), 
		НСтр("ru = 'Недопустимо значение параметра ИмяПараметра'"), Контекст);
		
	ЭтоКорректныйТип = ЗначениеОжидаемогоТипа(ЗначениеПараметра, ОжидаемыеТипы);
	Проверить(ЭтоКорректныйТип <> Неопределено, 
		НСтр("ru = 'Недопустимо значение параметра ОжидаемыеТипы'"), Контекст);
		
	НедопустимыйПараметр = НСтр("ru = 'Недопустимое значение параметра %1 в %2. 
		|Ожидалось: %3; передано значение: %4 (тип %5).'");
	Проверить(ЭтоКорректныйТип, СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НедопустимыйПараметр,
		ИмяПараметра,
		ИмяПроцедурыИлиФункции,
		ПредставлениеТипов(ОжидаемыеТипы), 
		?(ЗначениеПараметра <> Неопределено, ЗначениеПараметра, НСтр("ru = 'Неопределено'")),
		ТипЗнч(ЗначениеПараметра)));
			
	Если ТипЗнч(ЗначениеПараметра) = Тип("Структура") И ОжидаемыеТипыСвойств <> Неопределено Тогда
		
		Проверить(ТипЗнч(ОжидаемыеТипыСвойств) = Тип("Структура"), 
			НСтр("ru = 'Недопустимо значение параметра ИмяПроцедурыИлиФункции'"), Контекст);
			
		НетСвойства = НСтр("ru = 'Недопустимое значение параметра %1 (Структура) в %2. 
			|В структуре ожидалось свойство %3 (тип %4).'");
		НедопустимоеСвойство = НСтр("ru = 'Недопустимое значение свойства %1 в параметре %2 (Структура) в %3. 
			|Ожидалось: %4; передано значение: %5 (тип %6).'");
		Для каждого Свойство Из ОжидаемыеТипыСвойств Цикл
			
			ОжидаемоеИмяСвойства = Свойство.Ключ;
			ОжидаемыйТипСвойства = Свойство.Значение;
			ЗначениеСвойства = Неопределено;
			
			Проверить(ЗначениеПараметра.Свойство(ОжидаемоеИмяСвойства, ЗначениеСвойства), 
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НетСвойства, ИмяПараметра, ИмяПроцедурыИлиФункции, ОжидаемоеИмяСвойства, ОжидаемыйТипСвойства));
				
			ЭтоКорректныйТип = ЗначениеОжидаемогоТипа(ЗначениеСвойства, ОжидаемыйТипСвойства);
			Проверить(ЭтоКорректныйТип, СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НедопустимоеСвойство, 
				ОжидаемоеИмяСвойства,
				ИмяПараметра,
				ИмяПроцедурыИлиФункции,
				ПредставлениеТипов(ОжидаемыеТипы), 
				?(ЗначениеСвойства <> Неопределено, ЗначениеСвойства, НСтр("ru = 'Неопределено'")),
				ТипЗнч(ЗначениеСвойства)));
		КонецЦикла;
	КонецЕсли;		
	
КонецПроцедуры

Функция ЗначениеОжидаемогоТипа(Значение, ОжидаемыеТипы)
	ТипЗначения = ТипЗнч(Значение);
	Если ТипЗнч(ОжидаемыеТипы) = Тип("ОписаниеТипов") Тогда
		Возврат ОжидаемыеТипы.Типы().Найти(ТипЗначения) <> Неопределено;
	ИначеЕсли ТипЗнч(ОжидаемыеТипы) = Тип("Тип") Тогда
		Возврат ТипЗначения = ОжидаемыеТипы;
	ИначеЕсли ТипЗнч(ОжидаемыеТипы) = Тип("Массив") Или ТипЗнч(ОжидаемыеТипы) = Тип("ФиксированныйМассив") Тогда
		Возврат ОжидаемыеТипы.Найти(ТипЗначения) <> Неопределено;
	ИначеЕсли ТипЗнч(ОжидаемыеТипы) = Тип("Соответствие") Или ТипЗнч(ОжидаемыеТипы) = Тип("ФиксированноеСоответствие") Тогда
		Возврат ОжидаемыеТипы.Получить(ТипЗначения) <> Неопределено;
	КонецЕсли;
	Возврат Неопределено;
КонецФункции

Функция ПредставлениеТипов(ОжидаемыеТипы)
	Если ТипЗнч(ОжидаемыеТипы) = Тип("Массив") Тогда
		Результат = "";
		Индекс = 0;
		Для Каждого Тип Из ОжидаемыеТипы Цикл
			Если Не ПустаяСтрока(Результат) Тогда
				Результат = Результат + ", ";
			КонецЕсли;
			Результат = Результат + ПредставлениеТипа(Тип);
			Индекс = Индекс + 1;
			Если Индекс > 10 Тогда
				Результат = Результат + ",... "
					+ СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='(всего %1 типов)'"), ОжидаемыеТипы.Количество());
				Прервать;	
			КонецЕсли;	
		КонецЦикла;
		Возврат Результат;
	Иначе
		Возврат ПредставлениеТипа(ОжидаемыеТипы);
	КонецЕсли;
КонецФункции

Функция ПредставлениеТипа(Тип)
	Если Тип = Неопределено Тогда
		Возврат "Неопределено";
	ИначеЕсли ТипЗнч(Тип) = Тип("ОписаниеТипов") Тогда
		ТипСтрокой = Строка(Тип);
		Возврат ?(СтрДлина(ТипСтрокой) > 150, Лев(ТипСтрокой, 150) + "..." 
			+ СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='(всего %1 типов)'"), Тип.Типы().Количество()), 
			ТипСтрокой);
	Иначе	
		ТипСтрокой = Строка(Тип);
		Возврат ?(СтрДлина(ТипСтрокой) > 150, Лев(ТипСтрокой, 150) + "...", ТипСтрокой);
	КонецЕсли;	
КонецФункции

#КонецОбласти