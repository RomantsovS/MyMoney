﻿#Область СлужебныеПроцедурыИФункции

Функция ПараметрыРаботыКлиентаПриЗапуске() Экспорт
	
	Параметры = Новый Структура;
	
	ПараметрыКлиента = СтандартныеПодсистемыВызовСервера.ПараметрыРаботыКлиентаПриЗапуске(Параметры);
	
	СтандартныеПодсистемыКлиент.ЗаполнитьПараметрыКлиента(ПараметрыКлиента);
	
	Возврат ПараметрыКлиента;
	
КонецФункции

#КонецОбласти