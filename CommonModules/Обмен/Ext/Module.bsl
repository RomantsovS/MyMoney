﻿#Область ПрограммныйИнтерфейс

Процедура ЗарегистрироватьИзмененияДанных(УзелОбмена) Экспорт
	
	СоставПланаОбмена = УзелОбмена.Метаданные().Состав;
	Для Каждого ЭлементСоставаПланаОбмена Из СоставПланаОбмена Цикл
		ПланыОбмена.ЗарегистрироватьИзменения(УзелОбмена,ЭлементСоставаПланаОбмена.Метаданные);
	КонецЦикла;
	
КонецПроцедуры

Функция СформироватьПакетОбмена(УзелОбмена) Экспорт
	
	ЗаписьXML = Новый ЗаписьXML;
	
	ЗаписьXML.УстановитьСтроку("UTF-8");
	ЗаписьXML.ЗаписатьОбъявлениеXML();
	
	ЗаписьСообщения = ПланыОбмена.СоздатьЗаписьСообщения();
	ЗаписьСообщения.НачатьЗапись(ЗаписьXML, УзелОбмена);
	
	ЗаписьXML.ЗаписатьСоответствиеПространстваИмен("xsi", "http://www.w3.org/2001/XMLSchema-instance");
	ЗаписьXML.ЗаписатьСоответствиеПространстваИмен("v8", "http://v8.1c.ru/data");
	
	ВыборкаИзменений = ПланыОбмена.ВыбратьИзменения(УзелОбмена, ЗаписьСообщения.НомерСообщения);
	Пока ВыборкаИзменений.Следующий() Цикл
		Данные = ВыборкаИзменений.Получить();
		
		// Если перенос данных не нужен, то, возможно, необходимо записать удаление данных.
		Если Не НуженПереносДанных(Данные, УзелОбмена) Тогда
			
			// Получаем значение с возможным удалением данных.
			УдалениеДанных(Данные);
			
		Иначе
			Для Каждого стр из данные.метаданные().реквизиты Цикл
				Если ЛксПолучитьКорневойТипКонфигурации(данные[стр.имя]) = "Справочник" или
					ЛксПолучитьКорневойТипКонфигурации(данные[стр.имя]) = "Документ" Тогда 
					ЗаписатьДанные(ЗаписьXML, данные[стр.имя].получитьОбъект());
				КонецЕсли;
			КонецЦикла;
			
		КонецЕсли;
		
		// Записываем данные в сообщение.
		ЗаписатьДанные(ЗаписьXML, Данные);
		
	КонецЦикла;
	
	ЗаписьСообщения.ЗакончитьЗапись();
	
	Возврат Новый ХранилищеЗначения(ЗаписьXML.Закрыть(), Новый СжатиеДанных(9));
	
КонецФункции

Функция СформироватьПакетЗаказа(штрихкод) Экспорт 
	
	типНоменклатура = ФабрикаXDTO.Тип("http://localhost/wsExchange", "Номенклатура");
	типСписок = ФабрикаXDTO.Тип("http://localhost/wsExchange", "СписокТоваров");
	типЗаказ = ФабрикаXDTO.Тип("http://localhost/wsExchange", "Заказ");
	
	список = ФабрикаXDTO.Создать(типСписок);
	заказ = ФабрикаXDTO.Создать(типЗаказ);
	
	запрос = новый запрос("ВЫБРАТЬ
	|	Штрихкоды.Владелец
	|ИЗ
	|	РегистрСведений.Штрихкоды КАК Штрихкоды
	|ГДЕ
	|	Штрихкоды.Штрихкод = &Штрихкод
	|	И Штрихкоды.Владелец ССЫЛКА Документ.Заказ");
	запрос.УстановитьПараметр("штрихкод", штрихкод);
	
	рез = запрос.Выполнить().Выбрать();
	
	Если рез.Следующий() Тогда 
		заказ = ФабрикаXDTO.Создать(типЗаказ);
		
		запрос = новый запрос("ВЫБРАТЬ
		|	Заказ.Клиент.Наименование КАК Клиент,
		|	Заказ.Курьер.Наименование КАК Курьер,
		|	Заказ.Склад.Наименование КАК Склад,
		|	Заказ.ДатаДоставки,
		|	Заказ.АдресДоставки,
		|	Заказ.Ссылка
		|ИЗ
		|	Документ.Заказ КАК Заказ
		|ГДЕ
		|	Заказ.Ссылка = &Ссылка");
		запрос.УстановитьПараметр("ссылка", рез.владелец);
		
		резЗаказ = запрос.Выполнить().Выбрать();
		Если резЗаказ.Следующий() Тогда 
			ЗаполнитьЗначенияСвойств(заказ, резЗаказ);
		КонецЕсли;
		
		Для Каждого стр из резЗаказ.ссылка.товары Цикл
			ном = ФабрикаXDTO.Создать(типНоменклатура);
			ЗаполнитьЗначенияСвойств(ном, стр);
			ном.наименование = стр.товар.наименование;
		КонецЦикла;
		
		список.номенклатура.добавить(ном);
		
		заказ.товары = список;
	КонецЕсли;
	
	Возврат заказ;
КонецФункции

Функция НуженПереносДанных(Данные, УзелОбмена) Экспорт
	
	Перенос = Истина;
	//Если ТипЗнч(Данные) = Тип("ДокументОбъект.ВводОстатков") ИЛИ
	//	ТипЗнч(Данные) = Тип("ДокументОбъект.Операция") Тогда
	//	
	//	// Проверяем, что у документов курьер совпадает с реквизитом узла обмена.
	//	Если Не УзелОбмена.Курьер.Пустая() И Данные.Курьер <> УзелОбмена.Курьер Тогда
	//		Перенос = Ложь;
	//		
	//	КонецЕсли;
	//	
	//ИначеЕсли ТипЗнч(Данные) = Тип("СправочникОбъект.Пользователи") Тогда
	//	
	//	Если Не УзелОбмена.Курьер.Пустая() И Данные.Ссылка <> УзелОбмена.Курьер Тогда
	//		Перенос = Ложь;
	//		
	//	КонецЕсли;
	//	
	//КонецЕсли;
	
	Возврат Перенос;
	
КонецФункции

Процедура УдалениеДанных(Данные) Экспорт
	
	// Получаем объект описания метаданного, соответствующий данным.
	ОбъектМетаданных = ?(ТипЗнч(Данные) = Тип("УдалениеОбъекта"), Данные.Ссылка.Метаданные(), Данные.Метаданные());
	Если Метаданные.Справочники.Содержит(ОбъектМетаданных) ИЛИ Метаданные.Документы.Содержит(ОбъектМетаданных) Тогда
		
		// Перенос удаления объекта Для объектных.
		Данные = Новый УдалениеОбъекта(Данные.Ссылка);
		
	ИначеЕсли Метаданные.РегистрыСведений.Содержит(ОбъектМетаданных) Тогда
		
		// Очищаем данные.
		Данные.Очистить();
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаписатьДанные(ЗаписьXML, Данные) Экспорт
	ЗаписатьXML(ЗаписьXML, Данные);
	
КонецПроцедуры

Процедура ПринятьПакетОбмена(УзелОбмена, ДанныеОбмена) Экспорт
	
	ЧтениеXML = Новый ЧтениеXML;
	ЧтениеXML.УстановитьСтроку(ДанныеОбмена.Получить());
	ЧтениеСообщения = ПланыОбмена.СоздатьЧтениеСообщения();
	ЧтениеСообщения.НачатьЧтение(ЧтениеXML);
	
	ПланыОбмена.УдалитьРегистрациюИзменений(ЧтениеСообщения.Отправитель, ЧтениеСообщения.НомерПринятого);
	
	НачатьТранзакцию();
	Пока ВозможностьЧтенияXML(ЧтениеXML) Цикл
		
		Данные = ПрочитатьДанные(ЧтениеXML);
		
		Если Не Данные = Неопределено Тогда
			
			// Не переносим изменение, полученное от планшета, Если есть регистрация
			// изменения в офисе.
			Если Не ПринятьИзменения(ЧтениеСообщения.Отправитель, Данные) Тогда
				Продолжить;
				
			КонецЕсли;
			
			Данные.ОбменДанными.Отправитель = ЧтениеСообщения.Отправитель;
			Данные.ОбменДанными.Загрузка = Истина;
			
			Данные.Записать();
			
		КонецЕсли;
		
	КонецЦикла;
	
	ЗафиксироватьТранзакцию();
	
	ЧтениеСообщения.ЗакончитьЧтение();
	ЧтениеXML.Закрыть();
	
КонецПроцедуры

Функция ПрочитатьДанные(ЧтениеXML) Экспорт
	
	Возврат ПрочитатьXML(ЧтениеXML);
	
КонецФункции

Функция ПринятьИзменения(Отправитель, Данные) Экспорт
	
	Прием = Истина;
	//Если ПланыОбмена.ИзменениеЗарегистрировано(Отправитель, Данные) Тогда
	//	
	//	Если ТипЗнч(Данные) = Тип("СправочникОбъект.Клиенты")
	//		//ИЛИ ТипЗнч(Данные) = Тип("СправочникОбъект.ПричиныОтказа") 
	//		Тогда
	//		Прием = Ложь;
	//		
	//	КонецЕсли;
	//	
	//КонецЕсли;
	
	Возврат Прием;
	
КонецФункции

Функция ЛксПолучитьКорневойТипКонфигурации(Знач пОбъект) Экспорт

    Если ТипЗнч(пОбъект) = Тип("ОбъектМетаданных") Тогда 
        МетаданныеТипа = пОбъект;
    Иначе
        Если ТипЗнч(пОбъект) = Тип("ОписаниеТипов") Тогда
            Если пОбъект.Типы().Количество() > 0 Тогда 
                пОбъект = пОбъект.Типы()[0];
            Иначе
                Возврат Неопределено;
            КонецЕсли;
        КонецЕсли;
        Если ТипЗнч(пОбъект) = Тип("Тип") Тогда
            МетаданныеТипа = Метаданные.НайтиПоТипу(пОбъект);
        Иначе
            МетаданныеТипа = Метаданные.НайтиПоТипу(ТипЗнч(пОбъект));
        КонецЕсли;
    КонецЕсли;
    Если МетаданныеТипа <> Неопределено Тогда 
        МассивФрагментов = ЛксПолучитьМассивИзСтрокиСРазделителем(МетаданныеТипа.ПолноеИмя());
        Если МассивФрагментов.Количество() = 2 Тогда 
            Возврат МассивФрагментов[0];
        Иначе
            // Ссылка на субобъект
        КонецЕсли;
    КонецЕсли;
    Возврат Неопределено;
    
КонецФункции // ЛксПолучитьКорневойТипКонфигурации()

// Функция разбивает строку разделителем.
// 
// Параметры:
//  пСтрока      - Строка - которую разбиваем;
//  *пРазделитель - Строка - символ-разделитель.
//
// Возвращаемое значение:
//               - Массив - содержащий фрагменты, на которые разбивает строку разделитель.
//
Функция ЛксПолучитьМассивИзСтрокиСРазделителем(пСтрока, пРазделитель = ".") Экспорт
    
    Массив = Новый Массив;
    лСтрока = СтрЗаменить(пСтрока, пРазделитель, Символы.ПС);
    Для Счетчик = 1 По СтрЧислоСтрок(лСтрока) Цикл 
        Массив.Добавить(СтрПолучитьСтроку(лСтрока, Счетчик));
    КонецЦикла;
    Возврат Массив;
    
КонецФункции // ЛксПолучитьМассивИзСтрокиСРазделителем()

#КонецОбласти