﻿#Область ПрограммныйИнтерфейс

// Получает файл из Интернета по протоколу http(s), либо ftp и сохраняет его по указанному пути на сервере.
//
// Параметры:
//   URL                - Строка - url файла в формате [Протокол://]<Сервер>/<Путь к файлу на сервере>
//   ПараметрыПолучения - Структура со свойствами:
//      * ПутьДляСохранения    - Строка       - путь на сервере (включая имя файла), Для сохранения скачанного файла
//      * Пользователь         - Строка       - пользователь от имени которого установлено соединение
//      * Пароль               - Строка       - пароль пользователя от которого установлено соединение
//      * Порт                 - Число        - порт сервера с которым установлено соединение
//      * Таймаут              - Число        - таймаут на получение файла, в секундах
//      * ЗащищенноеСоединение - Булево       - Для случая http загрузки флаг указывает, что соединение должно производиться через https
//      * ПассивноеСоединение  - Булево       - Для случая ftp загрузки флаг указывает, что соединение должно пассивным (или активным)
//      * Заголовки            - Соответствие - см. описание параметра Заголовки объекта HTTPЗапрос
//   ЗаписыватьОшибку   - Булево - Признак необходимости записи ошибки в журнал регистрации при получении файла
//
// Возвращаемое значение:
//   Структура - Структура со свойствами:
//      * Статус            - Булево - результат получения файла
//      * Путь   - Строка   - путь к файлу на сервере, ключ используется только Если статус Истина
//      * СообщениеОбОшибке - Строка - сообщение об ошибке, Если статус Ложь
//      * Заголовки         - Соответствие - см. описание параметра Заголовки объекта HTTPОтвет
//
Функция СкачатьФайлНаСервере(Знач URL, ПараметрыПолучения = Неопределено) Экспорт
	
	НастройкиПолучения = ПолучениеФайловИзИнтернетаКлиентСервер.СтруктураПараметровПолученияФайла();
	
	Если ПараметрыПолучения <> Неопределено Тогда
		
		ЗаполнитьЗначенияСвойств(НастройкиПолучения, ПараметрыПолучения);
		
	КонецЕсли;
	
	НастройкаСохранения = Новый Соответствие;
	НастройкаСохранения.Вставить("МестоХранения", "Сервер");
	НастройкаСохранения.Вставить("Путь", НастройкиПолучения.ПутьДляСохранения);
	
	Возврат ПолучениеФайловИзИнтернетаКлиентСервер.ПодготовитьПолучениеФайла(URL,
		НастройкиПолучения, НастройкаСохранения);
	
КонецФункции

// Получает файл из Интернета по протоколу http(s), либо ftp и сохраняет его во временное хранилище..
//
// Параметры:
//   URL                - Строка - url файла в формате [Протокол://]<Сервер>/<Путь к файлу на сервере>
//   ПараметрыПолучения - Структура со свойствами:
//      * Пользователь         - Строка       - пользователь от имени которого установлено соединение
//      * Пароль               - Строка       - пароль пользователя от которого установлено соединение
//      * Порт                 - Число        - порт сервера с которым установлено соединение
//      * Таймаут              - Число        - таймаут на получение файла, в секундах
//      * ЗащищенноеСоединение - Булево       - Для случая http загрузки флаг указывает, что соединение должно производиться через https
//      * ПассивноеСоединение  - Булево       - Для случая ftp загрузки флаг указывает, что соединение должно пассивным (или активным)
//      * Заголовки            - Соответствие - см. описание параметра Заголовки объекта HTTPЗапрос
//   ЗаписыватьОшибку   - Булево - Признак необходимости записи ошибки в журнал регистрации при получении файла
//
// Возвращаемое значение:
//   Структура - Структура со свойствами:
//      * Статус            - Булево - результат получения файла
//      * Путь   - Строка   - адрес временного хранилища с двоичными данными файла, ключ используется только Если статус Истина
//      * СообщениеОбОшибке - Строка - сообщение об ошибке, Если статус Ложь
//      * Заголовки         - Соответствие - см. описание параметра Заголовки объекта HTTPОтвет
//
Функция СкачатьФайлВоВременноеХранилище(Знач URL, ПараметрыПолучения = Неопределено, Знач ЗаписыватьОшибку = Истина) Экспорт
	
	НастройкиПолучения = ПолучениеФайловИзИнтернетаКлиентСервер.СтруктураПараметровПолученияФайла();
	
	Если ПараметрыПолучения <> Неопределено Тогда
		
		ЗаполнитьЗначенияСвойств(НастройкиПолучения, ПараметрыПолучения);
		
	КонецЕсли;
	
	НастройкаСохранения = Новый Соответствие;
	НастройкаСохранения.Вставить("МестоХранения", "ВременноеХранилище");
	
	Возврат ПолучениеФайловИзИнтернетаКлиентСервер.ПодготовитьПолучениеФайла(URL,
		НастройкиПолучения, НастройкаСохранения, ЗаписыватьОшибку);
	
КонецФункции


#КонецОбласти



