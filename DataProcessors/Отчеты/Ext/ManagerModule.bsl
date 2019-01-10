﻿Процедура ДинамикаОстатковПоКошелькамКошелекПриИзмененииНаСервере(ТекОбъект) Экспорт 
	Если ТекОбъект.ОтборКошелек.Количество() > 0 Тогда 
		Если ТекОбъект.Периодичность = Перечисления.Периодичность.Регистратор Тогда 
			ТекОбъект.Периодичность = Перечисления.Периодичность.ПустаяСсылка();
		КонецЕсли;
		
		Если ТекОбъект.Элементы.Найти("ВычитатьДолгиИзОстатка") <> Неопределено Тогда 
			ТекОбъект.Элементы.ВычитатьДолгиИзОстатка.ТолькоПросмотр = Ложь;
		КонецЕсли;
	Иначе
		ТекОбъект.ВычитатьДолгиИзОстатка = Ложь;
		
		Если ТекОбъект.Элементы.Найти("ВычитатьДолгиИзОстатка") <> Неопределено Тогда 
			ТекОбъект.Элементы.ВычитатьДолгиИзОстатка.ТолькоПросмотр = Истина;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры