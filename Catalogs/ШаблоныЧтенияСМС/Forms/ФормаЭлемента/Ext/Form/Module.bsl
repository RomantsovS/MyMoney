﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СтрокаШаблонКарта = СтрЗаменить(Объект.ШаблонКарта, "%", "");
	СтрокаШаблонТипОперации = СтрЗаменить(Объект.ШаблонТипОперации, "%", "");
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если Не ЗначениеЗаполнено(СтрокаШаблонТипОперации) Тогда 
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Поле ""Шаблон тип операции"" не заполнен'"), , , "СтрокаШаблонТипОперации", Отказ);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Объект.НомерТелефона = СокрЛП(Объект.НомерТелефона);
	
	Объект.ШаблонКарта = "%" + СокрЛП(СтрокаШаблонКарта) + "%";
	Объект.ШаблонТипОперации = "%" + СокрЛП(СтрокаШаблонТипОперации) + "%";
	
	Объект.Порядок = СтрДлина(СтрокаШаблонТипОперации);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура НомерТелефонаПриИзменении(Элемент)
	
	СформироватьНаименование();
	
КонецПроцедуры

&НаКлиенте
Процедура ШаблонКартаПриИзменении(Элемент)
	
	СформироватьНаименование();
	
КонецПроцедуры

&НаКлиенте
Процедура ШаблонТипОперацииПриИзменении(Элемент)
	
	СформироватьНаименование();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура СформироватьНаименование()
	
	Объект.Наименование = Объект.НомерТелефона + " " + СокрЛП(СтрокаШаблонКарта) + " " + СокрЛП(СтрокаШаблонТипОперации);
	
КонецПроцедуры

#КонецОбласти