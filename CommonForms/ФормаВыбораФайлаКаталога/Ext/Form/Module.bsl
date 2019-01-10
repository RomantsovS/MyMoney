﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	#Если МобильноеПриложениеСервер Тогда
        Разделитель = "/";
    #Иначе

        Разделитель = "\";    
	#КонецЕсли
	
	Если не параметры.Свойство("каталог", Каталог) Тогда 
		Каталог = Константы.КаталогХраненияФайлов.Получить();
	КонецЕсли;
	
	Если не параметры.Свойство("формат", форматФайла) Тогда 
		форматФайла = "*.xml";
	КонецЕсли;
	
	ЭтаФорма.Заголовок = ЭтаФорма.Заголовок + " " + форматФайла;
КонецПроцедуры

&НаКлиенте
Процедура Выбор(Команда)
	Если Элементы.ТаблицаФайлов.ТекущиеДанные <> Неопределено Тогда 
		ЭтаФорма.Закрыть(Элементы.ТаблицаФайлов.ТекущиеДанные.ПолноеИмяФайла);
	Иначе
		ЭтаФорма.закрыть();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)	
	ОбновитьСписокПокаталогу();
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСписокПокаталогу()
	//Если ЗначениеЗаполнено(Каталог) Тогда 
	//	найденныеФайлы = НайтиФайлы(Каталог, форматФайла);
	//	
	//	Для Каждого НайденныйФайл из НайденныеФайлы Цикл
	//		Если НайденныйФайл.Существует() Тогда
	//			Если (РежимВыбораКаталога = Ложь) ИЛИ (РежимВыбораКаталога = Истина И НайденныйФайл.ЭтоКаталог()) Тогда
	//				НстрокаТЗ = ТаблицаФайлов.Добавить();
	//				НстрокаТЗ.ИмяФайла = НайденныйФайл.Имя; 
	//				НстрокаТЗ.ПолноеИмяФайла = НайденныйФайл.ПолноеИмя; 
	//				
	//				Если НайденныйФайл.ЭтоКаталог() Тогда
	//					НстрокаТЗ.папка = Истина;
	//				//Иначе
	//				//	НстрокаТЗ.Картинка = 1;    
	//				КонецЕсли;
	//			КонецЕсли;
	//		КонецЕсли;
	//	КонецЦикла;
	//	
	//	ТаблицаФайлов.Сортировать("Папка Убыв, ИмяФайла");
	//Иначе
	//	Сообщить("Ошибка получения каталога!");
	//	Возврат;
	//КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура КаталогПриИзменении(Элемент)
	ОбновитьСписокПокаталогу();
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаФайловВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	Если Элементы.ТаблицаФайлов.ТекущиеДанные <> Неопределено Тогда 
		ЭтаФорма.Закрыть(Элементы.ТаблицаФайлов.ТекущиеДанные.ПолноеИмяФайла);
	Иначе
		ЭтаФорма.закрыть();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура КаталогНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = ложь;
	
	//#Если не МобильноеПриложениеКлиент Тогда
	//	Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога);
	//	Диалог.Заголовок = "Укажите каталог информационной базы:";
	//	
	//	Если Диалог.Выбрать() Тогда
	//		Каталог = Диалог.Каталог;
	//	Иначе
	//		Возврат;
	//	КонецЕсли;
	//#Иначе		
	//	Если не ВвестиСтроку(Каталог) Тогда 
	//		Возврат;
	//	КонецЕсли;
	//#КонецЕсли
	//
	//ОбновитьСписокПокаталогу();
КонецПроцедуры
