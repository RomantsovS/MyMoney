﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	Если Основная и не Ссылка.Основная Тогда  
		запрос = Новый запрос("ВЫБРАТЬ
		|	КлючНастроек.Ссылка
		|ИЗ
		|	Справочник.КлючНастроек КАК КлючНастроек
		|ГДЕ
		|	КлючНастроек.Основная
		|	И КлючНастроек.КлючОбъекта = &КлючОбъекта");
		запрос.УстановитьПараметр("КлючОбъекта", КлючОбъекта); 
		
		рез = запрос.Выполнить().Выбрать();
		
		Если рез.Следующий() Тогда 
			об = рез.ссылка.получитьОбъект();
			об.основная = Ложь;
			об.записать();
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#КонецЕсли
