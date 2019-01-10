﻿&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)	
	ПодготовитьФормуНаСервере();
КонецПроцедуры

&НаСервере
Процедура ПодготовитьФормуНаСервере()	
	период.ДатаНачала = НачалоГода(ТекущаяДата());
	Период.ДатаОкончания = КонецДня(ТекущаяДата());
	
	ОбновитьТекущуюСтраницу();
КонецПроцедуры

&НаКлиенте
Процедура Настройки(Команда)
	структ = новый Структура;
	структ.Вставить("период", период);
	структ.Вставить("ОтборВалюта", ОтборВалюта);
	
	ОП = новый ОписаниеОповещения("НастройкаОтбораПослеИзменения", ЭтаФорма);
	
	ОткрытьФорму("Обработка.Отчеты.Форма.НастройкиОтбора", структ, , , , , ОП);
КонецПроцедуры

&НаКлиенте
Процедура НастройкаОтбораПослеИзменения(Результат, допПараметры) Экспорт 
	Если Результат <> Неопределено Тогда 
		период = Результат.период;
		
		ОтборВалюта.ЗагрузитьЗначения(результат.ОтборВалюта.выгрузитьЗначения());
		
		НастройкаОтбораПослеИзмененияСерв();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура НастройкаОтбораПослеИзмененияСерв()			
	ОтчетСформирован = ложь;
	
	ОбновитьТекущуюСтраницу();
КонецПроцедуры

&НаКлиенте
Процедура Группа2ПриСменеСтраницы(Элемент, ТекущаяСтраница)
	Группа2ПриСменеСтраницыСерв();	
КонецПроцедуры

&НаСервере
Процедура Группа2ПриСменеСтраницыСерв()
	ОбновитьТекущуюСтраницу();	
КонецПроцедуры

&НаСервере
Процедура ОбновитьТекущуюСтраницу()
	Если не ОтчетСформирован Тогда 
		ОбновитьОстаткиСервер(Элементы);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ОбновитьОстаткиСервер(элементы) Экспорт 
	Запрос = Новый Запрос; 
	запрос.УстановитьПараметр("НачалоПериода", период.ДатаНачала);
	запрос.УстановитьПараметр("КонецПериода", ?(период.ДатаОкончания = дата(1, 1, 1), период.ДатаОкончания, КонецДня(период.ДатаОкончания)));
	запрос.УстановитьПараметр("ОтборВалюта", ?(ОтборВалюта.Количество() = 0, Неопределено, ОтборВалюта));
	запрос.УстановитьПараметр("НеИспользоватьОтборВалюта", ОтборВалюта.Количество() = 0);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЗатратыОбороты.Регистратор,
	|	ЗатратыОбороты.ПериодГод,
	|	ЗатратыОбороты.ПериодМесяц,
	|	ЗатратыОбороты.СуммаОборот КАК ЗатратыОборот,
	|	0 КАК КошелькиОборот,
	|	ЗатратыОбороты.Валюта,
	|	0 КАК ДолгиОборот,
	|	ЗатратыОбороты.ПериодСекунда
	|ПОМЕСТИТЬ вт
	|ИЗ
	|	РегистрНакопления.Затраты.Обороты(
	|			&НачалоПериода,
	|			&КонецПериода,
	|			Авто,
	|			Валюта В (&ОтборВалюта)
	|				ИЛИ &НеИспользоватьОтборВалюта) КАК ЗатратыОбороты
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	КошелькиОбороты.Регистратор,
	|	КошелькиОбороты.ПериодГод,
	|	КошелькиОбороты.ПериодМесяц,
	|	0,
	|	КошелькиОбороты.СуммаОборот,
	|	КошелькиОбороты.Валюта,
	|	0,
	|	КошелькиОбороты.ПериодСекунда
	|ИЗ
	|	РегистрНакопления.Кошельки.Обороты(
	|			&НачалоПериода,
	|			&КонецПериода,
	|			Авто,
	|			Валюта В (&ОтборВалюта)
	|				ИЛИ &НеИспользоватьОтборВалюта) КАК КошелькиОбороты
	|ГДЕ
	|	КошелькиОбороты.Регистратор.ТипОперации <> ЗНАЧЕНИЕ(перечисление.типыопераций.перевод)
	|	И НЕ КошелькиОбороты.Регистратор ССЫЛКА Документ.ВводОстатков
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ДолгиОбороты.Регистратор,
	|	ДолгиОбороты.ПериодГод,
	|	ДолгиОбороты.ПериодМесяц,
	|	0,
	|	0,
	|	ДолгиОбороты.Валюта,
	|	ДолгиОбороты.СуммаОборот,
	|	ДолгиОбороты.ПериодСекунда
	|ИЗ
	|	РегистрНакопления.Долги.Обороты(
	|			&НачалоПериода,
	|			&КонецПериода,
	|			Авто,
	|			Валюта В (&ОтборВалюта)
	|				ИЛИ &НеИспользоватьОтборВалюта) КАК ДолгиОбороты
	|ГДЕ
	|	НЕ ДолгиОбороты.Регистратор.НеУчитыватьРасхождениеДолговЗатрат
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	вт.Регистратор,
	|	вт.ПериодГод КАК ПериодГод,
	|	вт.ПериодМесяц КАК ПериодМесяц,
	|	СУММА(вт.ЗатратыОборот) КАК ЗатратыОборот,
	|	СУММА(вт.КошелькиОборот) КАК КошелькиОборот,
	|	вт.Валюта КАК Валюта,
	|	СУММА(вт.ДолгиОборот) КАК ДолгиОборот,
	|	СУММА(вт.ЗатратыОборот - вт.КошелькиОборот - вт.ДолгиОборот) КАК Разница,
	|	вт.ПериодСекунда
	|ИЗ
	|	вт КАК вт
	|ГДЕ
	|	вт.Регистратор.ТипОперации <> ЗНАЧЕНИЕ(перечисление.типыопераций.сторно)
	|
	|СГРУППИРОВАТЬ ПО
	|	вт.Регистратор,
	|	вт.ПериодГод,
	|	вт.ПериодМесяц,
	|	вт.Валюта,
	|	вт.ПериодСекунда
	|
	|ИМЕЮЩИЕ
	|	СУММА(вт.ЗатратыОборот - вт.КошелькиОборот - вт.ДолгиОборот) <> 0
	|
	|УПОРЯДОЧИТЬ ПО
	|	вт.ПериодСекунда
	|ИТОГИ
	|	СУММА(ЗатратыОборот),
	|	СУММА(КошелькиОборот),
	|	СУММА(ДолгиОборот),
	|	СУММА(Разница)
	|ПО
	|	Валюта,
	|	ПериодГод,
	|	ПериодМесяц";
	
	результатЗапроса = запрос.Выполнить();
	ВыборкаВалюта = результатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	ТабДок = новый ТабличныйДокумент;
	
	макет = РеквизитФормыВЗначение("Объект").ПолучитьМакет("МакетПроверкаДолгиЗатраты");
	
	облСтрока = макет.получитьОбласть("Строка");
	
	ТабДок.НачатьАвтогруппировкуСтрок();
	
	Пока ВыборкаВалюта.Следующий() Цикл		
		облСтрока.параметры.измерение = ВыборкаВалюта.Валюта.краткоеНаименование;
		облСтрока.параметры.измерениеРасшифровка = Неопределено;
		облСтрока.параметры.разница = ВыборкаВалюта.разница;
		
		ТабДок.Вывести(облСтрока, 1);
		
		выборкаГод = ВыборкаВалюта.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		
		Пока выборкаГод.Следующий() Цикл			
			облСтрока.параметры.измерение = формат(выборкаГод.периодГод, "ДФ=гггг");
			облСтрока.параметры.измерениеРасшифровка = Неопределено;
			облСтрока.параметры.разница = выборкаГод.разница;
			
			ТабДок.Вывести(облСтрока, 2);
			
			выборкаМесяц = выборкаГод.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
			
			Пока выборкаМесяц.Следующий() Цикл			
				облСтрока.параметры.измерение = формат(выборкаМесяц.периодМесяц, "ДФ=гггг.МММ");
				облСтрока.параметры.измерениеРасшифровка = Неопределено;
				облСтрока.параметры.разница = выборкаМесяц.разница;
				
				ТабДок.Вывести(облСтрока, 3);
				
				выборка = выборкаМесяц.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
				
				Пока выборка.Следующий() Цикл				
					облСтрока.параметры.измерение = выборка.регистратор;
					облСтрока.параметры.измерениеРасшифровка = выборка.регистратор;
					облСтрока.параметры.разница =  выборка.разница;
					
					ТабДок.Вывести(облСтрока, 4);
				КонецЦикла;
			КонецЦикла;
		КонецЦикла;
	КонецЦикла;
	
	ТабДок.ЗакончитьАвтогруппировкуСтрок();
	
	мас = новый Массив;
	#Если МобильноеПриложениеСервер Тогда
		мас.Добавить(100);
		мас.Добавить(60);
		мас.Добавить(75);
		мас.Добавить(100);
	#Иначе
		мас.Добавить(100);
		мас.Добавить(90);
		мас.Добавить(100);
		мас.Добавить(100);
		
		элементы.ТабДок.ОтображатьГруппировки = Истина;
	#КонецЕсли
	
	ОбщегоНазначения.РасчетШириныКолонок(ТабДок, мас);
	
	отчетСформирован = Истина;
КонецПроцедуры
