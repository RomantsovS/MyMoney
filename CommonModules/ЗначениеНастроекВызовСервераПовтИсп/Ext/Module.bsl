﻿
#Область ПрограммныйИнтерфейс

Функция ТекущаяВерсияПриложения() Экспорт
	
	ТекущаяВерсияПриложения = ЗначениеНастроекПовтИсп.ПолучитьЗначениеКонстанты("ТекущаяВерсияПриложения");
	
	// версия Для разработчиков
	Если СтрЧислоВхождений(ТекущаяВерсияПриложения, ".") = 3 И Прав(ТекущаяВерсияПриложения, 2) = ".0" Тогда
		ТекущаяВерсияПриложения = Сред(ТекущаяВерсияПриложения, 1, СтрДлина(ТекущаяВерсияПриложения) - 2);
	КонецЕсли;
	
	Возврат ТекущаяВерсияПриложения;
	
КонецФункции

Функция КаталогХраненияФайлов() Экспорт 
	текКаталог = ЗначениеНастроекПовтИсп.ПолучитьЗначениеКонстанты("КаталогХраненияФайлов");
	
	#Если МобильноеПриложениеСервер Тогда
		каталогПоУмолчанию = "/storage/sdcard0/MyMoney/";
	#Иначе
		каталогПоУмолчанию = "";
	#КонецЕсли
	
	Возврат ?(ЗначениеЗаполнено(текКаталог), текКаталог, каталогПоУмолчанию);
КонецФункции

Функция ПолучитьЗначениеКонстанты(ИмяКонстанты) Экспорт 
	Возврат ЗначениеНастроекПовтИсп.ПолучитьЗначениеКонстанты(ИмяКонстанты);
КонецФункции

#КонецОбласти
