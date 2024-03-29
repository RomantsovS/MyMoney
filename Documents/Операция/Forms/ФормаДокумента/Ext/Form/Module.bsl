﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	КошелекПриемникПриИзмененииНаСервере();
	
	УстановитьВидимостьПоТипуОперации();
	
	УстановитьВидимостьПоТипуДолга();
	
	УстановитьУсловноеОформление();
	
	УстановитьВидимостьПоОбщимЗатратам();
	УстановитьДоступностьВалюты();
	УстановитьВидимостьДопСуммы();
	УстановитьВидимостьФизЛица();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ПриИзмененииКошельковОбщаяКлиент();
	
	ЗаголовокКурса();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	ТекстСообщения = "";
	
	Если Объект.Курс < 1 Тогда 
		ПеревернутьКурс(Объект.Курс, Объект.КурсПрямой);
	КонецЕсли;
	
	ПередЗаписьюСервПроверкаОстатков(ТекстСообщения);
	
	Если ТекстСообщения <> "" Тогда 
		ПоказатьВопрос(Новый ОписаниеОповещения("ПередЗаписьюВопросПроверкиОстатковЗавершение", ЭтотОбъект), 
		ТекстСообщения, РежимДиалогаВопрос.ДаНетОтмена);
		
		Отказ = Истина;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	Если ЗавершениеРаботы Тогда 
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда 
		Текст = "";
		
		Если ТекущаяДата() - Объект.Дата < 86400 Тогда 
			ПередЗакрытиемСервПроверкаОстатков(Текст);
		КонецЕсли;
		
		Если Текст <> "" Тогда 
			ПоказатьПредупреждение(, Текст);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ТипОперацииПриИзменении(Элемент)
	
	ТипОперацииПриИзмененииСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура СуммаПриИзменении(Элемент)
	Если Объект.ТипОперации = ПредопределенноеЗначение("Перечисление.ТипыОпераций.Перевод") И ЗначениеЗаполнено(КошелекПриемникВалюта) Тогда 
		ПересчитатьСуммуПриемник();
	ИначеЕсли Объект.ОбщиеЗатраты Тогда 
		Объект.СуммаОбщиеЗатраты = Объект.Сумма;
		
		ПересчитатьСуммаОбщихЗатрат();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура КошелекПриИзменении(Элемент)
	
	КошелекПриИзмененииНаСервере();
	
	ПриИзмененииКошельковОбщаяКлиент();
	
	УстановитьДоступностьВалюты();
	
КонецПроцедуры

&НаКлиенте
Процедура КошелекПриемникПриИзменении(Элемент)
	КошелекПриемникПриИзмененииНаСервере();
	
	ПриИзмененииКошельковОбщаяКлиент(Истина);
КонецПроцедуры

&НаКлиенте
Процедура ОбщиеЗатратыПриИзменении(Элемент)
	
	ПриИзмененииОбщиеЗатратыСерв();
	
	УстановитьВидимостьФизЛица();
	
	ПересчитатьСуммаОбщихЗатрат();
	
КонецПроцедуры

&НаСервере
Процедура ПриИзмененииОбщиеЗатратыСерв()
	
	УстановитьВидимостьПоОбщимЗатратам();
	
	Если Не ЗначениеЗаполнено(Объект.ФизЛицо) Тогда 
		Запрос = Новый Запрос("ВЫБРАТЬ ПЕРВЫЕ 1
		|	Операция.ФизЛицо
		|ИЗ
		|	Документ.Операция КАК Операция
		|ГДЕ
		|	Операция.ОбщиеЗатраты
		|
		|УПОРЯДОЧИТЬ ПО
		|	Операция.МоментВремени УБЫВ");	
		Рез = Запрос.Выполнить();
		
		Если Не Рез.Пустой() Тогда 
			Выборка = Рез.Выбрать();
			Выборка.Следующий();
			
			Объект.ФизЛицо = Выборка.физЛицо;
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура КурсПриИзменении(Элемент)
	Если Объект.ТипОперации = ПредопределенноеЗначение("Перечисление.ТипыОпераций.Перевод") Тогда 
		ПересчитатьСуммуПриемник();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СуммаПриходПриИзменении(Элемент)
	Если Объект.КурсПрямой Тогда 
		Объект.Сумма = Объект.СуммаПриемник / Объект.Курс;
	Иначе
		Объект.Сумма = Объект.СуммаПриемник * Объект.Курс;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СтатьяНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	
	ОП = Новый ОписаниеОповещения("СтатьяОкончаниеВыбора", ЭтотОбъект);
	
	ОткрытьФорму("Справочник.Статьи.Форма.ФормаВыбора", Новый Структура("Кошелек, Статья", Объект.Кошелек, Объект.Статья),
	ЭтаФорма, , , , ОП, РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
КонецПроцедуры

&НаКлиенте
Процедура ТипДолгаПриИзменении(Элемент)
	
	ТипДолгаПриИзмененииСервер();
	
КонецПроцедуры

&НаСервере
Процедура ТипДолгаПриИзмененииСервер()
	
	Если Объект.ТипДолга = Перечисления.ТипыДолгов.Зачисление Или Объект.ТипДолга = Перечисления.ТипыДолгов.Списание
		Или  Объект.ТипДолга = Перечисления.ТипыДолгов.Взаимозачет Тогда 
		Объект.Кошелек = Неопределено;
	КонецЕсли;
	
	УстановитьВидимостьПоТипуДолга();
	
	УстановитьДоступностьВалюты();
	
	УстановитьВидимостьДопСуммы();
	
КонецПроцедуры

&НаКлиенте
Процедура МеткаПриИзменении(Элемент)
	
	УстановитьВидимостьДопСуммы();
	
КонецПроцедуры

&НаСервере
Процедура ОснованиеПриИзмененииНаСервере()
	
	ТекОбъект = РеквизитФормыВЗначение("Объект");
	
	ТекОбъект.Заполнить(Объект.Основание);
	
	ЗначениеВРеквизитФормы(ТекОбъект, "Объект");
	
КонецПроцедуры

&НаКлиенте
Процедура ОснованиеПриИзменении(Элемент)
	ОснованиеПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура СуммаОбщиеЗатратыПриИзменении(Элемент)
	
	Объект.СуммаДолг = Объект.СуммаОбщиеЗатраты / 2;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура УдалитьОперацию(Команда)
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Объект Не записан'"));
		
		Закрыть();
		Возврат;
	КонецЕсли;
	
	ПоказатьВопрос(Новый ОписаниеОповещения("УдалитьОперациюВопросЗавершение", ЭтотОбъект), НСтр("ru = 'Вы уверены, что хотите удалить операцию?'"),
	РежимДиалогаВопрос.ОКОтмена);
КонецПроцедуры

&НаКлиенте
Процедура ВвестиКурс(Команда)
	ОткрытьФормуВводаКурсаВалют();
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	Попытка
		ПараметрыЗаписи = Новый  Структура;
		ПараметрыЗаписи.Вставить("РежимЗаписи", РежимЗаписиДокумента.Проведение);
		Записать(ПараметрыЗаписи);
	Исключение
		ОбщегоНазначенияКлиент.СообщитьПользователю(СтрШаблон(НСтр("ru = ''"), ПодробноеПредставлениеОшибки(ИнформацияОбОшибке())));
		Возврат;
	КонецПопытки;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПередЗаписьюВопросПроверкиОстатковЗавершение(Ответ, ДопПараметры) Экспорт 
	Если Ответ = КодВозвратаДиалога.Отмена Тогда 
		отказ = Истина;
		
		Возврат;
	ИначеЕсли Ответ = КодВозвратаДиалога.Нет Тогда 
		Отказ = Истина;
		Модифицированность = Ложь;
		
		Закрыть();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьПоТипуОперации()
	НовыйПараметрКошелек = Неопределено;
	НовыйПараметрСтатья = Неопределено;
	
	ЭтоСторно = Объект.ТипОперации = Перечисления.ТипыОпераций.Сторно;
	
	Элементы.Основание.Видимость = ЭтоСторно;
	
	Элементы.Кошелек.Заголовок = ?(Объект.ТипОперации = Перечисления.ТипыОпераций.Перевод, НСтр("ru = 'С кошелька'"),
	НСтр("ru = 'Кошелек'"));
	
	Элементы.Статья.Видимость = Объект.ТипОперации <> Перечисления.ТипыОпераций.Перевод;
	
	Элементы.ГруппаОбщиеЗатраты.Видимость = Объект.ТипОперации = Перечисления.ТипыОпераций.Расход
	Или Объект.ТипОперации = Перечисления.ТипыОпераций.Доход Или ЭтоСторно;
	
	Элементы.ГруппаПеревод.Видимость = Объект.ТипОперации = Перечисления.ТипыОпераций.Перевод;
	
	Элементы.ГруппаДолги.Видимость = Объект.ТипОперации = Перечисления.ТипыОпераций.Долги;
	
	Элементы.Статья.ТолькоПросмотр = ЭтоСторно;
	Элементы.Метка.ТолькоПросмотр = ЭтоСторно;
	Элементы.ФизЛицо.ТолькоПросмотр = ЭтоСторно;
		
	Если Объект.ТипОперации = Перечисления.ТипыОпераций.Перевод Тогда 
		НовыйПараметрКошелек = Новый ПараметрВыбора("Отбор.ОперацииПеревод", Истина);
	ИначеЕсли Объект.ТипОперации = Перечисления.ТипыОпераций.Долги Тогда
		НовыйПараметрКошелек = Новый ПараметрВыбора("Отбор.ОперацииДолги", Истина);
	Иначе		
		Если Объект.ТипОперации = Перечисления.ТипыОпераций.Расход Тогда 
			НовыйПараметрКошелек = Новый ПараметрВыбора("Отбор.ОперацииРасход", Истина);
			НовыйПараметрСтатья = Новый ПараметрВыбора("Отбор.Расходная", Истина);
		ИначеЕсли Объект.ТипОперации = Перечисления.ТипыОпераций.Доход Тогда 
			НовыйПараметрКошелек = Новый ПараметрВыбора("Отбор.ОперацииДоход", Истина);
			НовыйПараметрСтатья = Новый ПараметрВыбора("Отбор.Доходная", Истина);
		КонецЕсли;
	КонецЕсли;
	
	МассивПараметровВыбораКошелек = Новый Массив;
	МассивПараметровВыбораСтатья = Новый Массив;
	
	Если НовыйПараметрКошелек <> Неопределено Тогда  
		МассивПараметровВыбораКошелек.Добавить(НовыйПараметрКошелек);
	КонецЕсли;
	
	Если НовыйПараметрСтатья <> Неопределено Тогда  
		МассивПараметровВыбораСтатья.Добавить(НовыйПараметрСтатья);
	КонецЕсли;
	
	НовыеПараметры = Новый ФиксированныйМассив(МассивПараметровВыбораКошелек);
	Элементы.Кошелек.ПараметрыВыбора = НовыеПараметры;
	Элементы.КошелекПриемник.ПараметрыВыбора = НовыеПараметры;
	
	НовыеПараметры = Новый ФиксированныйМассив(МассивПараметровВыбораСтатья);
	Элементы.Статья.ПараметрыВыбора = НовыеПараметры;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьФизЛица()
	
	Элементы.ФизЛицо.Видимость = Объект.ТипОперации = Перечисления.ТипыОпераций.Долги Или Объект.ОбщиеЗатраты;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииКошельковОбщаяКлиент(ВводитьКурс = Ложь)
	ПроверитьВалютыКошельковВвестиКурс(ВводитьКурс);
КонецПроцедуры

&НаСервере
Процедура КошелекПриИзмененииНаСервере()
	Объект.Валюта = Объект.Кошелек.Валюта;
КонецПроцедуры

&НаСервере
Процедура УстановитьДоступностьВалюты()
	Элементы.Валюта.ТолькоПросмотр = ЗначениеЗаполнено(Объект.Кошелек);
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьВалютыКошельковВвестиКурс(ВводитьКурс = Ложь)
	Если ЗначениеЗаполнено(Объект.Валюта) И ЗначениеЗаполнено(КошелекПриемникВалюта) И Объект.Валюта <> КошелекПриемникВалюта Тогда 
		Если ВводитьКурс Тогда 
			ОткрытьФормуВводаКурсаВалют();
		КонецЕсли;
		
		Элементы.Курс.ТолькоПросмотр = Ложь;
		Элементы.ВвестиКурс.Доступность = Истина;
	Иначе
		Объект.Курс = 1;
		Элементы.Курс.ТолькоПросмотр = Истина;
		Элементы.ВвестиКурс.Доступность = Ложь;
		
		Если ЗначениеЗаполнено(КошелекПриемникВалюта) И ВводитьКурс Тогда 
			ПересчитатьСуммуПриемник();
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуВводаКурсаВалют()
	Парам = Новый Структура("Валюта1, Валюта2, Курс, КурсПрямой", Объект.Валюта, КошелекПриемникВалюта, Объект.Курс, Объект.КурсПрямой);
	
	ОП = Новый ОписаниеОповещения("ОбработкаОткрытияФормыВводаКурса", ЭтаФорма, Парам);
	ОткрытьФорму("ОбщаяФорма.ФормаВводаКурсаВалют", Парам, ЭтаФорма, , , , ОП, РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОткрытияФормыВводаКурса(Результат, Параметры) Экспорт 
	Если Результат = Неопределено Тогда 
		Возврат;
	Иначе
		Если Результат.Курс > 1 Тогда 
			Объект.Курс = Результат.Курс;
			Объект.КурсПрямой = Результат.КурсПрямой;
		Иначе
			ПеревернутьКурс(Результат.Курс, Результат.КурсПрямой);			
		КонецЕсли;
	КонецЕсли;
	
	ПересчитатьСуммуПриемник();
	
	ЗаголовокКурса();
КонецПроцедуры

&НаКлиенте
Процедура ЗаголовокКурса()
	Элементы.Курс.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
	НСтр("ru = 'Курс %1 / %2'"), ?(Объект.КурсПрямой, Объект.Валюта, КошелекПриемникВалютаКраткоеНаименование),
	?(Объект.КурсПрямой, КошелекПриемникВалютаКраткоеНаименование, Объект.Валюта));
КонецПроцедуры

&НаКлиенте
Процедура ПеревернутьКурс(КурсРасчет, текКурсПрямой)
	Объект.Курс = ?(КурсРасчет = 0, 0, Окр(1 / КурсРасчет, 2));
	Объект.КурсПрямой = Не текКурсПрямой;
КонецПроцедуры

&НаКлиенте
Процедура ПересчитатьСуммуПриемник()
	Если Объект.КурсПрямой Тогда 
		Объект.СуммаПриемник = Объект.Сумма * Объект.Курс;
	Иначе
		Объект.СуммаПриемник = Объект.Сумма / Объект.Курс;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура КошелекПриемникПриИзмененииНаСервере()
	КошелекПриемникВалюта = Объект.КошелекПриемник.Валюта;
	КошелекПриемникВалютаКраткоеНаименование = КошелекПриемникВалюта.КраткоеНаименование;
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьПоТипуДолга()
	Если Объект.ТипОперации = Перечисления.ТипыОпераций.Долги Тогда 
		Если Объект.ТипДолга = Перечисления.ТипыДолгов.Зачисление Или Объект.ТипДолга = Перечисления.ТипыДолгов.Списание Тогда 
			Элементы.Кошелек.Видимость = Ложь;
			Элементы.Статья.Видимость = Истина;
			Элементы.МеткаОтправитель.Видимость = Ложь;
		ИначеЕсли Объект.ТипДолга = Перечисления.ТипыДолгов.Взаимозачет Тогда 
			Элементы.Кошелек.Видимость = Ложь;
			Элементы.Статья.Видимость = Ложь;
			Элементы.МеткаОтправитель.Видимость = Истина;
		Иначе
			Элементы.Кошелек.Видимость = Истина;
			Элементы.Статья.Видимость = Ложь;
			Элементы.МеткаОтправитель.Видимость = Ложь;
		КонецЕсли;
	Иначе
		Элементы.МеткаОтправитель.Видимость = Ложь;		
		Элементы.Кошелек.Видимость = Истина;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ТипОперацииПриИзмененииСервер()
	
	УстановитьВидимостьПоТипуОперации();
	
	УстановитьВидимостьПоТипуДолга();
	
	УстановитьВидимостьПоОбщимЗатратам();

	УстановитьВидимостьДопСуммы();
	
	УстановитьВидимостьФизЛица();
	
КонецПроцедуры

&НаСервере
Процедура УдалитьОперациюНаСервере() 
	ОбъектОперация = Объект.Ссылка.ПолучитьОбъект();
	ОбъектОперация.удалить();
КонецПроцедуры

&НаКлиенте
Процедура УдалитьОперациюВопросЗавершение(Ответ, ДопПараметры) Экспорт 
	Если Ответ = КодВозвратаДиалога.Отмена Тогда 
		Возврат;
	КонецЕсли;
	
	УдалитьОперациюНаСервере();
	
	Оповестить("ОбновитьОстатки");
	
	Если ТипЗнч(ВладелецФормы) = Тип("ТаблицаФормы") И ТипЗнч(ВладелецФормы.Родитель) = Тип("УправляемаяФорма") И 
		ВладелецФормы.Родитель.ИмяФормы = "Документ.Операция.Форма.ФормаСписка" Тогда 
		ВладелецФормы.Родитель.Элементы.Список.Обновить();
	КонецЕсли;
	
	Закрыть();
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюСервПроверкаОстатков(ТекстСообщения)
	Если Не (ЗначениеЗаполнено(Объект.Кошелек) И (Объект.ТипОперации = Перечисления.ТипыОпераций.Расход
		Или Объект.ТипОперации = Перечисления.ТипыОпераций.Перевод
		Или (Объект.ТипОперации = Перечисления.ТипыОпераций.Долги И Объект.ТипДолга = Перечисления.ТипыДолгов.Дебет))) Тогда 
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	|	КошелькиОстатки.СуммаОстаток
	|ИЗ
	|	РегистрНакопления.Кошельки.Остатки(&момент, кошелек = &кошелек) КАК КошелькиОстатки");
	Запрос.УстановитьПараметр("кошелек", Объект.Кошелек);
	Запрос.УстановитьПараметр("момент", Объект.Дата);
	
	Рез = Запрос.Выполнить().Выбрать();
	
	Если Рез.Следующий() Тогда 
		Если (ЗначениеЗаполнено(Объект.Ссылка) И Рез.СуммаОстаток < 0) Или
			(Не ЗначениеЗаполнено(Объект.Ссылка) И Рез.СуммаОстаток < Объект.Сумма) Тогда 
			ТекстСообщения = СтрШаблон(НСтр("ru = 'Превышен остаток по кошельку %1. Доступно %2. Превышение %3 %4.
			| Все равно записать?'"), Объект.Кошелек,
			Рез.СуммаОстаток, (Объект.Сумма - Рез.СуммаОстаток), Объект.Кошелек.Валюта);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("ОбновитьОстатки");
	
	Закрыть();
КонецПроцедуры

&НаСервере
Функция ПередЗакрытиемСервПроверкаОстатков(текст)
	Запрос = Новый Запрос("ВЫБРАТЬ
	|	КошелькиОстатки.СуммаОстаток,
	|	КошелькиОстатки.Кошелек.МинимальныйОстаток КАК МинимальныйОстаток
	|ИЗ
	|	РегистрНакопления.Кошельки.Остатки(&момент, кошелек = &кошелек) КАК КошелькиОстатки
	|ГДЕ
	|	КошелькиОстатки.Кошелек.МинимальныйОстаток > 0
	|	И КошелькиОстатки.СуммаОстаток <= КошелькиОстатки.Кошелек.МинимальныйОстаток");
	Запрос.УстановитьПараметр("кошелек", Объект.Кошелек);
	Запрос.УстановитьПараметр("момент", Объект.Дата + 1);
	
	Рез = Запрос.Выполнить();
	
	Если Не Рез.Пустой() Тогда 
		Выборка = Рез.Выбрать();
		Выборка.Следующий();
		
		Текст = СтрШаблон(НСтр("ru = 'Остаток по кошельку %1 меньше минимального %2'"), Выборка.СуммаОстаток, Выборка.МинимальныйОстаток);
	КонецЕсли;
КонецФункции

&НаКлиенте
Процедура СтатьяОкончаниеВыбора(Результат, ДопПараметры) Экспорт 
	Если Результат = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	Объект.Статья = Результат;
КонецПроцедуры

&НаКлиенте
Процедура ПересчитатьСуммаОбщихЗатрат()
	
	Если Объект.ОбщиеЗатраты Тогда 
		Объект.СуммаОбщиеЗатраты = Объект.Сумма;
		Объект.СуммаДолг = Объект.Сумма / 2;
	Иначе
		Объект.СуммаОбщиеЗатраты = 0;
		Объект.СуммаДолг = 0;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьПоОбщимЗатратам()
	
	Элементы.СуммаОбщиеЗатраты.Видимость = Объект.ОбщиеЗатраты;
	Элементы.СуммаДолг.Видимость = Объект.ОбщиеЗатраты;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьДопСуммы()
	
	Если Объект.ТипОперации = Перечисления.ТипыОпераций.Долги И Объект.ТипДолга <> Перечисления.ТипыДолгов.Взаимозачет Тогда 
		Если ЗначениеЗаполнено(Объект.Метка) Тогда 
			Элементы.СуммаДолг1.Видимость = Истина;
		Иначе
			Элементы.СуммаДолг1.Видимость = Ложь;
			Объект.СуммаДолг = 0;
		КонецЕсли;
	Иначе
		Элементы.СуммаДолг1.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
КонецПроцедуры

#КонецОбласти
