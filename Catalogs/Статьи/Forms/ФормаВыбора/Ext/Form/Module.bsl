﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Запрос = Новый Запрос("ВЫБРАТЬ
	|	ПРЕДСТАВЛЕНИЕ(Статьи.Ссылка),
	|	Статьи.Ссылка КАК Ссылка,
	|	Статьи.ЭтоГруппа
	|ИЗ
	|	Справочник.Статьи КАК Статьи
	|ГДЕ
	|	ВЫБОР
	|			КОГДА &Расходная = Ложь
	|						И &Доходная = Ложь
	|					ИЛИ &Расходная = ИСТИНА
	|						И &Доходная = ИСТИНА
	|				ТОГДА ИСТИНА
	|			ИНАЧЕ (&Расходная = Ложь
	|					ИЛИ Статьи.Расходная)
	|					И (&Доходная = Ложь
	|						ИЛИ Статьи.Доходная)
	|		КОНЕЦ
	|
	|УПОРЯДОЧИТЬ ПО
	|	Статьи.Код ИЕРАРХИЯ");
	
	Если Параметры.Свойство("Кошелек") Тогда 
		Запрос.УстановитьПараметр("Расходная", Параметры.Кошелек.ОперацииРасход);
		Запрос.УстановитьПараметр("Доходная", Параметры.Кошелек.ОперацииДоход);
	Иначе
		Запрос.УстановитьПараметр("Расходная", Ложь);
		Запрос.УстановитьПараметр("Доходная", Ложь);
	КонецЕсли;
	
	Рез = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией);
	
	ВывестиУровеньДерева(Рез, Дерево.ПолучитьЭлементы());	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ДеревоВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	
	текСтрока = Дерево.НайтиПоИдентификатору(ВыбраннаяСтрока);
	
	Если текСтрока <> Неопределено Тогда 
		Если не текСтрока.ЭтоГруппа Тогда 
			Закрыть(Дерево.НайтиПоИдентификатору(ВыбраннаяСтрока).ссылка);
		Иначе
			Если Элементы.Дерево.Развернут(ВыбраннаяСтрока) Тогда 
				Элементы.Дерево.Свернуть(ВыбраннаяСтрока);
			Иначе
				Элементы.Дерево.Развернуть(ВыбраннаяСтрока);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ВывестиУровеньДерева(рез, текЭлементы)
	Пока рез.Следующий() Цикл 
		НоваяСтрока = текЭлементы.Добавить();		
		НоваяСтрока.код = рез.ссылкаПредставление;
		НоваяСтрока.ссылка = рез.ссылка;
		НоваяСтрока.ЭтоГруппа = рез.ЭтоГруппа;
		
		Если рез.ЭтоГруппа Тогда 
			рез2 = рез.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией);
			ВывестиУровеньДерева(рез2, НоваяСтрока.получитьЭлементы());			
		КонецЕсли;
	КонецЦикла;	
КонецПроцедуры

#КонецОбласти
