﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	очистилиОтборы = Ложь;
	
	Если Параметры.Свойство("ОтборПоКошельку") Тогда 
		Если Не очистилиОтборы Тогда 
			Список.Отбор.Элементы.Очистить();
			очистилиОтборы = Истина;
		КонецЕсли;
		
		ГруппаЭлементовОтбора = Список.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
		ГруппаЭлементовОтбора.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;
		ГруппаЭлементовОтбора.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Обычный;		
		
		ЭлементОтбора = ГруппаЭлементовОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.ЛевоеЗначение    = Новый ПолеКомпоновкиДанных("Кошелек");
		Если ТипЗнч(Параметры.ОтборПоКошельку) = Тип("Массив") Тогда
			ЭлементОтбора.ВидСравнения     = ВидСравненияКомпоновкиДанных.ВСписке;
		Иначе
			ЭлементОтбора.ВидСравнения     = ВидСравненияКомпоновкиДанных.Равно;
		КонецЕсли;
		ЭлементОтбора.Использование    = Истина;
		ЭлементОтбора.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Обычный;
		ЭлементОтбора.ПравоеЗначение   = Параметры.ОтборПоКошельку;	
		
		ЭлементОтбора = ГруппаЭлементовОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.ЛевоеЗначение    = Новый ПолеКомпоновкиДанных("КошелекПриемник");
		Если ТипЗнч(Параметры.ОтборПоКошельку) = Тип("Массив") Тогда
			ЭлементОтбора.ВидСравнения     = ВидСравненияКомпоновкиДанных.ВСписке;
		Иначе
			ЭлементОтбора.ВидСравнения     = ВидСравненияКомпоновкиДанных.Равно;
		КонецЕсли;
		ЭлементОтбора.Использование    = Истина;
		ЭлементОтбора.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Обычный;
		ЭлементОтбора.ПравоеЗначение   = Параметры.ОтборПоКошельку;
	КонецЕсли;
	
	Если Параметры.Свойство("отборПоФизЛицу") Тогда 
		Если Не очистилиОтборы Тогда 
			Список.Отбор.Элементы.Очистить();
			очистилиОтборы = Истина;
		КонецЕсли;
		
		ЭлементОтбора = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных")); 
		ЭлементОтбора.ЛевоеЗначение    = Новый ПолеКомпоновкиДанных("ФизЛицо");
		ЭлементОтбора.ВидСравнения     = ВидСравненияКомпоновкиДанных.Равно;
		ЭлементОтбора.Использование    = Истина;
		ЭлементОтбора.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Обычный;
		ЭлементОтбора.ПравоеЗначение   = Параметры.отборПоФизЛицу;
	КонецЕсли;
	
	Если Параметры.Свойство("отборПоСтатье") Тогда 
		Если Не очистилиОтборы Тогда 
			Список.Отбор.Элементы.Очистить();
			очистилиОтборы = Истина;
		КонецЕсли;
		
		ЭлементОтбора = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных")); 
		ЭлементОтбора.ЛевоеЗначение    = Новый ПолеКомпоновкиДанных("Статья");
		Если Параметры.отборПоСтатье.этоГруппа Тогда 
			ЭлементОтбора.ВидСравнения     = ВидСравненияКомпоновкиДанных.ВИерархии;
		Иначе
			ЭлементОтбора.ВидСравнения     = ВидСравненияКомпоновкиДанных.Равно;
		КонецЕсли;
		ЭлементОтбора.Использование    = Истина;
		ЭлементОтбора.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.БыстрыйДоступ;
		ЭлементОтбора.ПравоеЗначение   = Параметры.отборПоСтатье;
	КонецЕсли;
	
	Если Параметры.Свойство("отборПоВалюте") Тогда 
		Если Не очистилиОтборы Тогда 
			Список.Отбор.Элементы.Очистить();
			очистилиОтборы = Истина;
		КонецЕсли;
		
		ЭлементОтбора = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных")); 
		ЭлементОтбора.ЛевоеЗначение    = Новый ПолеКомпоновкиДанных("Валюта");
		Если ТипЗнч(Параметры.отборПоВалюте) = Тип("Массив") Тогда
			ЭлементОтбора.ВидСравнения     = ВидСравненияКомпоновкиДанных.ВСписке;
		Иначе
			ЭлементОтбора.ВидСравнения     = ВидСравненияКомпоновкиДанных.Равно;
		КонецЕсли;
		ЭлементОтбора.Использование    = Истина;
		ЭлементОтбора.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.БыстрыйДоступ;
		ЭлементОтбора.ПравоеЗначение   = Параметры.отборПоВалюте;
	КонецЕсли;
	
	Если Параметры.Свойство("отборПоМетке") Тогда 
		Если Не очистилиОтборы Тогда 
			Список.Отбор.Элементы.Очистить();
			очистилиОтборы = Истина;
		КонецЕсли;
		
		ЭлементОтбора = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных")); 
		ЭлементОтбора.ЛевоеЗначение    = Новый ПолеКомпоновкиДанных("Метка");
		Если ТипЗнч(Параметры.отборПоМетке) = Тип("Массив") Тогда
			ЭлементОтбора.ВидСравнения     = ВидСравненияКомпоновкиДанных.ВСписке;
		Иначе
			ЭлементОтбора.ВидСравнения     = ВидСравненияКомпоновкиДанных.Равно;
		КонецЕсли;
		ЭлементОтбора.Использование    = Истина;
		ЭлементОтбора.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.БыстрыйДоступ;
		ЭлементОтбора.ПравоеЗначение   = Параметры.отборПоМетке;
	КонецЕсли;
	
	Если Параметры.Свойство("отборПоПериоду") Тогда 
		Если Не очистилиОтборы Тогда 
			Список.Отбор.Элементы.Очистить();
			очистилиОтборы = Истина;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Параметры.отборПоПериоду.началоПериода) Тогда 
		ЭлементОтбора = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных")); 
		ЭлементОтбора.ЛевоеЗначение    = Новый ПолеКомпоновкиДанных("Дата");
		ЭлементОтбора.ВидСравнения     = ВидСравненияКомпоновкиДанных.БольшеИлиРавно;
		ЭлементОтбора.Использование    = Истина;
		ЭлементОтбора.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Обычный;
		ЭлементОтбора.ПравоеЗначение   = Параметры.отборПоПериоду.началоПериода;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Параметры.отборПоПериоду.КонецПериода) Тогда 
			ЭлементОтбора = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных")); 
			ЭлементОтбора.ЛевоеЗначение    = Новый ПолеКомпоновкиДанных("Дата");
			ЭлементОтбора.ВидСравнения     = ВидСравненияКомпоновкиДанных.МеньшеИлиРавно;
			ЭлементОтбора.Использование    = Истина;
			ЭлементОтбора.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Обычный;
			ЭлементОтбора.ПравоеЗначение   = Параметры.отборПоПериоду.КонецПериода;
		КонецЕсли;
	КонецЕсли;
	
	Элементы.Список.НачальноеОтображениеСписка = НачальноеОтображениеСписка.Начало;
	
	УстановитьУсловноеОформление();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура УдалитьОперацию(Команда)
	ДанныеОперации = УдалитьОперациюНаСервереПолучитьДанные();
	
	Если ДанныеОперации = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ПоказатьВопрос(Новый ОписаниеОповещения("ВопросУдалитьЗавершение", ЭтотОбъект),
	СтрШаблон(НСтр("ru = 'Вы уверены, что хотите удалить операцию на сумму %1?'", ДанныеОперации)), РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	новЭлем = УсловноеОформление.Элементы.Добавить();
	ПолеЭлемента = новЭлем.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Сумма.Имя);
	ПолеЭлемента = новЭлем.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СуммаОбщиеЗатраты.Имя);
	ОтборЭлемента = новЭлем.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.ТипОперации");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.ТипыОпераций.Доход;
	новЭлем.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.Зеленый);
	новЭлем.Использование = Истина;
	
	новЭлем = УсловноеОформление.Элементы.Добавить();
	ПолеЭлемента = новЭлем.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Сумма.Имя);	
	ПолеЭлемента = новЭлем.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СуммаОбщиеЗатраты.Имя);
	ОтборЭлемента = новЭлем.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.ТипОперации");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.ТипыОпераций.Расход;	
	новЭлем.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.Красный);
	новЭлем.Использование = Истина;
	
	новЭлем = УсловноеОформление.Элементы.Добавить();
	ПолеЭлемента = новЭлем.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Сумма.Имя);	
	ОтборЭлемента = новЭлем.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.ТипОперации");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.ТипыОпераций.Перевод;	
	новЭлем.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.СветлоНебесноГолубой);	
	новЭлем.Использование = Истина;	
	
	новЭлем = УсловноеОформление.Элементы.Добавить();
	ПолеЭлемента = новЭлем.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Дата.Имя);	
	ОтборЭлемента = новЭлем.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.Дата");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.БольшеИлиРавно;
	ОтборЭлемента.ПравоеЗначение = НачалоДня(ТекущаяДата());	
	новЭлем.Оформление.УстановитьЗначениеПараметра("Формат", "ДФ=ЧЧ:мм");	
	новЭлем.Использование = Истина;
	
	новЭлем = УсловноеОформление.Элементы.Добавить();
	ПолеЭлемента = новЭлем.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Дата1.Имя);	
	ОтборЭлемента = новЭлем.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.Дата");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.БольшеИлиРавно;
	ОтборЭлемента.ПравоеЗначение = НачалоДня(ТекущаяДата());	
	новЭлем.Оформление.УстановитьЗначениеПараметра("Формат", "ДФ='дд МММ'");	
	новЭлем.Использование = Истина;
КонецПроцедуры

&НаСервере
Процедура УдалитьОперациюНаСервере()
	Если Элементы.Список.ТекущаяСтрока <> Неопределено Тогда 
		ОбъектОперация = Элементы.Список.ТекущаяСтрока.Ссылка.получитьОбъект();
		ОбъектОперация.Заблокировать();
		ОбъектОперация.Удалить();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция УдалитьОперациюНаСервереПолучитьДанные()
	Если Элементы.Список.ТекущаяСтрока <> Неопределено Тогда 
		Возврат Строка(Элементы.Список.ТекущаяСтрока.Ссылка.Сумма) + Элементы.Список.ТекущаяСтрока.Ссылка.Кошелек.Валюта.КраткоеНаименование;
	КонецЕсли;
	
	Возврат Неопределено;
КонецФункции

&НаКлиенте
Процедура ВопросУдалитьЗавершение(Результат, ДопПараметры) Экспорт 
	
	Если Результат = КодВозвратаДиалога.Нет Тогда 
		Возврат;
	КонецЕсли;
	
	УдалитьОперациюНаСервере();
	
	Элементы.Список.Обновить();
	
	Оповестить("ОбновитьОстатки");
	
КонецПроцедуры

#КонецОбласти