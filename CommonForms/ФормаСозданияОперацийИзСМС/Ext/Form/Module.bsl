﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Элементы.СписокДата.Ширина = 7;
	Элементы.СписокДата1.Ширина = 7;
	
	УстановитьУсловноеОформление();
	
	Период.Вариант = ВариантСтандартногоПериода.СНачалаЭтойНедели;
	
	Параметры.Свойство("ОтборШаблон", ОтборШаблон);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОбновитьСписокОперацийСМС();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Обновить(Команда)
	
	ОбновитьСписокОпераций();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекДанные = Элементы.Список.ТекущиеДанные;
	
	Если ТекДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ТекДанные.Операция) Тогда
		ПоказатьЗначение(, ТекДанные.Операция);
	Иначе
		Парам = Новый Структура("Кошелек, Дата, Сумма, ТипОперации");
		
		ЗаполнитьЗначенияСвойств(Парам, ТекДанные);
		
		Если ТекДанные.ПередаватьКомментарий Тогда 
			Парам.Вставить("Комментарий", ТекДанные.Комментарий);
		КонецЕсли;
		
		ОткрытьФорму("Документ.Операция.ФормаОбъекта", Новый Структура("ЗначенияЗаполнения", Парам), , , , ,
		Новый ОписаниеОповещения("СоздатьОперациюЗавершение", ЭтотОбъект));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПутьКФайлуНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	Диалог.МножественныйВыбор = Ложь;
	Диалог.Заголовок = НСтр("ru = 'Укажите путь к файлу:'");
	
	Диалог.Показать(Новый ОписаниеОповещения("ПутьКФайлуВыборЗавершение", ЭтотОбъект));
	
КонецПроцедуры

&НаКлиенте
Процедура ПутьКФайлуВыборЗавершение(Результат, ДопПараметры) Экспорт 
	
	Если Результат = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ПутьКФайлу = Результат[0];
	
	ОбновитьСписокОпераций();
	
КонецПроцедуры


#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	СтандартныеПодсистемыСервер.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "Список.Дата", Элементы.СписокДата.Имя);
	
	СтандартныеПодсистемыСервер.УстановитьУсловноеОформлениеПоТипуОперации(ЭтотОбъект, "Список.ТипОперации", Элементы.СписокСумма.Имя);
	
	СтандартныеПодсистемыСервер.УстановитьГоризонтальноеПоложениеСумма(ЭтотОбъект, Элементы.СписокСумма.Имя);
	
	СтандартныеПодсистемыСервер.УстановитьПараметрыСпискаЭлементСумма(ЭтотОбъект, Элементы.СписокСумма.Имя);
	
	СтандартныеПодсистемыСервер.УстановитьПараметрыСпискаЭлементКошелек(ЭтотОбъект, Элементы.СписокКошелек.Имя);
	
	СтандартныеПодсистемыСервер.УстановитьПараметрыСпискаЭлементКомментарий(ЭтотОбъект, Элементы.СписокКомментарий.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСписокОпераций()
	
	Если Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаСМС Тогда 
		ОбновитьСписокОперацийСМС();
	Иначе
		ОбновитьСписокОперацийOFX();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСписокОперацийСМС()
	
	Список.Очистить();
	
	МассивТелефонов = ПолучитьШаблоныСМСНомераТелефонов(ОтборШаблон);
	
	МассивСМС = СМССообщенияКлиент.ПолучениеСМССообщения(МассивТелефонов, Период);
	
	МассивДанныхСМС = Новый Массив;
	
	ЧасовойПоясUTC = ЗначениеНастроекВызовСервераПовтИсп.ПолучитьЗначениеКонстанты("ЧасовойПоясUTC");
	
	Для Каждого СМССообщение Из МассивСМС Цикл 
		ДатаПолучения = СМССообщение.ДатаПолучения + ЧасовойПоясUTC * 3600;		
		
		СтруктураДанных = Новый Структура;
		СтруктураДанных.Вставить("Дата", ДатаПолучения);
		СтруктураДанных.Вставить("НомерТелефона", СМССообщение.НомераТелефонов[0]);
		СтруктураДанных.Вставить("Текст", СМССообщение.Текст);		
		
		МассивДанныхСМС.Добавить(СтруктураДанных);
	КонецЦикла;
	
	ОбновитьСписокОперацийСервер(МассивДанныхСМС);
	
	Заголовок = СтрШаблон(НСтр("ru = 'Создание операций из СМС (%1)'"), Список.Количество());
	
КонецПроцедуры

&НаСервере
Функция ТаблицаВнешнихДанныхОпераций()
	
	ТЗ = Новый ТаблицаЗначений;
	ТЗ.Колонки.Добавить("Дата", Новый ОписаниеТипов("Дата"));
	ТЗ.Колонки.Добавить("Кошелек", Новый ОписаниеТипов("СправочникСсылка.Кошельки"));
	ТЗ.Колонки.Добавить("ТипОперации", Новый ОписаниеТипов("ПеречислениеСсылка.ТипыОпераций"));
	ТЗ.Колонки.Добавить("Сумма", Новый ОписаниеТипов("Число"));
	ТЗ.Колонки.Добавить("Комментарий", Новый ОписаниеТипов("Строка", , , , Новый КвалификаторыСтроки(100)));
	ТЗ.Колонки.Добавить("ПередаватьКомментарий", Новый ОписаниеТипов("Булево"));
	
	Возврат ТЗ;
	
КонецФункции

&НаСервере
Процедура ОбновитьСписокОперацийСервер(МассивДанныхСМС)
	
	ТЗ = Новый ТаблицаЗначений;
	ТЗ.Колонки.Добавить("Текст", Новый ОписаниеТипов("Строка", , , , Новый КвалификаторыСтроки(250)));
	ТЗ.Колонки.Добавить("НомерТелефона", Новый ОписаниеТипов("Строка", , , , Новый КвалификаторыСтроки(10)));
	
	Для Каждого Стр Из МассивДанныхСМС Цикл 
		НоваяСтрока = ТЗ.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Стр);
	КонецЦикла;
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	|	ТЗ.Текст КАК Текст,
	|	ТЗ.НомерТелефона КАК НомерТелефона
	|ПОМЕСТИТЬ ВТ
	|ИЗ
	|	&ТЗ КАК ТЗ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ.Текст КАК Текст,
	|	ШаблоныЧтенияСМС.Ссылка КАК Ссылка,
	|	ШаблоныЧтенияСМС.Порядок КАК Порядок
	|ПОМЕСТИТЬ ВТ2
	|ИЗ
	|	ВТ КАК ВТ
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ШаблоныЧтенияСМС КАК ШаблоныЧтенияСМС
	|		ПО ВТ.НомерТелефона = ШаблоныЧтенияСМС.НомерТелефона
	|			И (ВТ.Текст ПОДОБНО ШаблоныЧтенияСМС.ШаблонКарта
	|				ИЛИ ПОДСТРОКА(ШаблоныЧтенияСМС.ШаблонКарта, 2, 1) = ""%%"")
	|			И (ВТ.Текст ПОДОБНО ШаблоныЧтенияСМС.ШаблонТипОперации)
	|			И (ПОДСТРОКА(ШаблоныЧтенияСМС.ШаблонТипОперации, 2, 1) <> ""%"")
	|ГДЕ
	|	((&ОтборШаблон = ЗНАЧЕНИЕ(Справочник.ШаблоныЧтенияСМС.) И ШаблоныЧтенияСМС.Использовать)
	|			ИЛИ ШаблоныЧтенияСМС.Ссылка = &ОтборШаблон)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ2.Текст КАК Текст,
	|	МАКСИМУМ(ВТ2.Порядок) КАК Порядок
	|ПОМЕСТИТЬ ВТ_Максимум
	|ИЗ
	|	ВТ2 КАК ВТ2
	|
	|СГРУППИРОВАТЬ ПО
	|	ВТ2.Текст
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ2.Ссылка КАК Ссылка,
	|	ВТ2.Текст КАК Текст,
	|	ВТ2.Ссылка.НомерТелефона КАК НомерТелефона,
	|	ВТ2.Ссылка.Кошелек КАК Кошелек,
	|	ВТ2.Ссылка.ТипОперации КАК ТипОперации,
	|	ВТ2.Ссылка.ШаблонКарта КАК ШаблонКарта,
	|	ВТ2.Ссылка.ШаблонТипОперации КАК ШаблонТипОперации,
	|	ВТ2.Ссылка.ШаблонСумма КАК ШаблонСумма,
	|	ВТ2.Ссылка.ШаблонКомментарий КАК ШаблонКомментарий
	|ИЗ
	|	ВТ_Максимум КАК ВТ_Максимум
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ2 КАК ВТ2
	|		ПО ВТ_Максимум.Текст = ВТ2.Текст
	|			И ВТ_Максимум.Порядок = ВТ2.Порядок");
	
	Запрос.УстановитьПараметр("ТЗ", ТЗ);
	Запрос.УстановитьПараметр("ОтборШаблон", ОтборШаблон);
	
	Рез = Запрос.Выполнить().Выбрать();
	
	ТЗ = ТаблицаВнешнихДанныхОпераций();
	
	СтруктураПоиска = Новый Структура("Текст");
	
	Для Каждого Стр Из МассивДанныхСМС Цикл 
		ЗаполнитьЗначенияСвойств(СтруктураПоиска, Стр);
		Рез.Сбросить();
		
		Пока Рез.НайтиСледующий(СтруктураПоиска) Цикл
			НоваяСтрока = ТЗ.Добавить();
			
			НоваяСтрока.Дата = Стр.Дата;
			
			ЗаполнитьЗначенияСвойств(НоваяСтрока, Рез);
			
			Если Рез.ШаблонСумма <> "" Тогда 
				ПозицияШаблонСумма = СтрНайти(Стр.Текст, Рез.ШаблонСумма);
				
				Если ПозицияШаблонСумма > 0 Тогда 
					ТекстСуммаБезШаблонаСуммы = СокрЛП(Лев(Стр.Текст, ПозицияШаблонСумма - 1));
					
					ПозицияПробелПередСуммой = СтрНайти(ТекстСуммаБезШаблонаСуммы, " ", НаправлениеПоиска.СКонца);
					
					Если ПозицияПробелПередСуммой > 0 Тогда 
						ТекстСумма = СокрЛП(Сред(ТекстСуммаБезШаблонаСуммы, ПозицияПробелПередСуммой));
						
						СтрокаСимволов = "0123456789.";
						
						ИтоговаяСтрокаСумма = "";
						
						Для Индекс = 1 По СтрДлина(ТекстСумма) Цикл 
							Символ = Сред(ТекстСумма, Индекс, 1);
							
							Если СтрНайти(СтрокаСимволов, Символ) > 0 Тогда
								ИтоговаяСтрокаСумма = ИтоговаяСтрокаСумма + Символ;
							КонецЕсли;
						КонецЦикла;
						
						Сумма = 0;
						
						Попытка
							Сумма = Число(ИтоговаяСтрокаСумма);
						Исключение
							ТекстОшибки = ОписаниеОшибки();
							Сообщить(СтрШаблон(НСтр("ru = 'Ошибка получения суммы из текста: %1. %2'"), ТекстСумма, ТекстОшибки));
						КонецПопытки;
						
						НоваяСтрока.Сумма = Сумма;
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
			
			Если Рез.ШаблонКомментарий <> "" Тогда 
				ПозицияШаблонКомментарий = СтрНайти(Стр.Текст, Рез.ШаблонКомментарий);
				
				Если ПозицияШаблонСумма > 0 Тогда 
					ТекстСуммаБезШаблонаКомментарий = СокрЛП(Сред(Стр.Текст, ПозицияШаблонКомментарий + СтрДлина(Рез.ШаблонКомментарий)));
					
					ПозицияТочкаПослеКомментария = СтрНайти(ТекстСуммаБезШаблонаКомментарий, ". ");
					
					Если ПозицияТочкаПослеКомментария > 0 Тогда 
						ТекстКомментарий = СокрЛП(Сред(ТекстСуммаБезШаблонаКомментарий, 1, ПозицияТочкаПослеКомментария));
						
						НоваяСтрока.Комментарий = ТекстКомментарий;
						НоваяСтрока.ПередаватьКомментарий = Истина;
					КонецЕсли;
				КонецЕсли;
			Иначе
				НоваяСтрока.Комментарий = Стр.Текст;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	ОбработатьТаблицуВнешнихДанныхОпераций(ТЗ);
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьТаблицуВнешнихДанныхОпераций(ТЗ)
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	|	ТЗ.Дата КАК Дата,
	|	ТЗ.ТипОперации КАК ТипОперации,
	|	ТЗ.Сумма КАК Сумма,
	|	ТЗ.Кошелек КАК Кошелек,
	|	ТЗ.Комментарий КАК Комментарий,
	|	ТЗ.ПередаватьКомментарий КАК ПередаватьКомментарий
	|ПОМЕСТИТЬ ВТ
	|ИЗ
	|	&ТЗ КАК ТЗ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ.Дата КАК Дата,
	|	ВТ.ТипОперации КАК ТипОперации,
	|	ВТ.Сумма КАК Сумма,
	|	ВТ.Кошелек КАК Кошелек,
	|	ВТ.Комментарий КАК Комментарий,
	|	ВТ.ПередаватьКомментарий КАК ПередаватьКомментарий,
	|	Операция.Ссылка КАК Операция,
	|	НЕ Операция.Ссылка ЕСТЬ NULL КАК ЕстьОперация
	|ИЗ
	|	ВТ КАК ВТ
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.Операция КАК Операция
	|		ПО (НАЧАЛОПЕРИОДА(ВТ.Дата, ЧАС) = НАЧАЛОПЕРИОДА(Операция.Дата, ЧАС))
	|			И ВТ.Сумма = Операция.Сумма
	|			И (ВТ.Кошелек = Операция.Кошелек
	|				ИЛИ ВТ.Кошелек = Операция.КошелекПриемник)");
	Запрос.УстановитьПараметр("ТЗ", ТЗ);
	
	Список.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьСписокОперацийOFX()
	
	Список.Очистить();
	
	Если Не ЗначениеЗаполнено(ПутьКФайлу) Тогда 
		Возврат;
	КонецЕсли;
	
	Чтение = Новый ЧтениеXML;
	Чтение.ОткрытьФайл(ПутьКФайлу);
	ДанныеФайла = ФабрикаXDTO.ПрочитатьXML(Чтение);
	
	ТЗ = ТаблицаВнешнихДанныхОпераций();
	Кошелек = Константы.ОсновнойКошелек.Получить();
	
	Для Каждого ОперацияФайла Из ДанныеФайла.BANKMSGSRSV1.STMTTRNRS.STMTRS.BANKTRANLIST.STMTTRN Цикл 
		НоваяСтрока = ТЗ.Добавить();
		НоваяСтрока.Дата = Дата(Лев(ОперацияФайла.DTPOSTED, 4), Сред(ОперацияФайла.DTPOSTED, 5, 2),
		Сред(ОперацияФайла.DTPOSTED, 7, 2), Сред(ОперацияФайла.DTPOSTED, 9, 2), Сред(ОперацияФайла.DTPOSTED, 11, 2),
		Сред(ОперацияФайла.DTPOSTED, 13, 2));
		
		НоваяСтрока.ТипОперации = ?(ОперацияФайла.TRNTYPE = "CREDIT", Перечисления.ТипыОпераций.Доход, Перечисления.ТипыОпераций.Расход);
		НоваяСтрока.Сумма = СтрЗаменить(ОперацияФайла.TRNAMT, "-", "");
		НоваяСтрока.Кошелек = Кошелек;
		НоваяСтрока.Комментарий = СтрШаблон("%1 %2", ОперацияФайла.NAME, ОперацияФайла.MEMO);
	КонецЦикла;
	
	ОбработатьТаблицуВнешнихДанныхОпераций(ТЗ);
	
	Заголовок = СтрШаблон(НСтр("ru = 'Создание операций из OFX (%1)'"), Список.Количество());
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьШаблоныСМСНомераТелефонов(ОтборШаблон)
	
	Запрос = Новый Запрос("ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ШаблоныЧтенияСМС.НомерТелефона КАК НомерТелефона
	|ИЗ
	|	Справочник.ШаблоныЧтенияСМС КАК ШаблоныЧтенияСМС
	|ГДЕ
	|	(&ОтборШаблон = ЗНАЧЕНИЕ(Справочник.ШаблоныЧтенияСМС.)
	|			ИЛИ ШаблоныЧтенияСМС.Ссылка = &ОтборШаблон)");
	
	Запрос.УстановитьПараметр("ОтборШаблон", ОтборШаблон);
	
	Рез = Запрос.Выполнить().Выгрузить();
	
	МассивТелефонов = Рез.ВыгрузитьКолонку("НомерТелефона");
	
	Возврат МассивТелефонов;
	
КонецФункции

&НаКлиенте
Процедура СоздатьОперациюЗавершение(Результат, ДопПараметры) Экспорт 
	
	ОбновитьСписокОпераций();
	
КонецПроцедуры

#КонецОбласти