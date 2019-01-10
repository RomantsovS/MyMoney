﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПоказатьВопрос(Новый ОписаниеОповещения("УдалитьВопросЗавершение", ЭтотОбъект, Новый Структура("Объект, Форма",
	ПараметрКоманды, ПараметрыВыполненияКоманды.Источник)), СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
	НСтр("ru = 'Вы уверены, что хотите удалить ""%1""?'"), ПараметрКоманды), РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьВопросЗавершение(Результат, ДопПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Нет Тогда 
		Возврат;
	КонецЕсли;
	
	ТекстСообщения = "";
	
	РезультатУдаления = ОбщегоНазначенияВызовСервера.УдалитьОбъектСПроверкой(ДопПараметры.Объект, ТекстСообщения);
	
	ПоказатьПредупреждение(, ТекстСообщения);
	
	Если РезультатУдаления Тогда 
		Если СтрНайти(ДопПараметры.Форма.ИмяФормы, "ФормаЭлемента") Тогда 
			ДопПараметры.Форма.Закрыть();
		Иначе
			ДопПараметры.Форма.Элементы.Список.Обновить();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры
