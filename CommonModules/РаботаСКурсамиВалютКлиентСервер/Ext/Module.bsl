﻿#Область ПрограммныйИнтерфейс

// Пересчитывает Сумму из Текущей валюты в Новую валюту по параметрам их курсов. 
//   Параметры курсов валют можно получить воспользовавшись функцией 
//   РаботаСКурсамиВалют.ПолучитьКурсВалюты(Валюта, ДатаКурса).
//
// Параметры:
//   Сумма                  - Число     - Сумма, которую следует пересчитать.
//   ПараметрыТекущегоКурса - Структура - Параметры курса валюты, из которой надо пересчитать.
//       * Валюта    - СправочникСсылка.Валюты - Ссылка пересчитываемой валюты.
//       * Курс      - Число - Курс пересчитываемой валюты.
//       * Кратность - Число - Кратность пересчитываемой валюты.
//   ПараметрыНовогоКурса   - Структура - Параметры курса валюты, в  которую надо пересчитать.
//       * Валюта    - СправочникСсылка.Валюты - Ссылка валюты, в которую идет пересчет.
//       * Курс      - Число - Курс валюты, в которую идет пересчет.
//       * Кратность - Число - Кратность валюты, в которую идет пересчет.
//
// Возвращаемое значение: 
//   Число - Сумма, пересчитанная по новому курсу.
//
Функция ПересчитатьПоКурсу(Сумма, ПараметрыТекущегоКурса, ПараметрыНовогоКурса) Экспорт
	Если ПараметрыТекущегоКурса.Валюта = ПараметрыНовогоКурса.Валюта
		ИЛИ (
			ПараметрыТекущегоКурса.Курс = ПараметрыНовогоКурса.Курс 
			И ПараметрыТекущегоКурса.Кратность = ПараметрыНовогоКурса.Кратность
		) Тогда
		
		Возврат Сумма;
		
	КонецЕсли;
	
	Если ПараметрыТекущегоКурса.Курс = 0
		ИЛИ ПараметрыТекущегоКурса.Кратность = 0
		ИЛИ ПараметрыНовогоКурса.Курс = 0
		ИЛИ ПараметрыНовогоКурса.Кратность = 0 Тогда
		
		ВалютаБезКурса = ?(ПараметрыТекущегоКурса.Курс = 0 Или ПараметрыТекущегоКурса.Кратность = 0, ПараметрыТекущегоКурса.Валюта, ПараметрыНовогоКурса.Валюта);
		
		Сообщить(
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'При пересчете из валюты %1 в валюту %2 сумма %3 установлена в нулевое значение, т.к. курс валюты %4 не задан.'"), 
				ПараметрыТекущегоКурса.Валюта,
				ПараметрыНовогоКурса.Валюта, 
				Формат(Сумма, "ЧДЦ=2; ЧН=0"),
				ВалютаБезКурса));
		
		Возврат 0;
		
	КонецЕсли;
	
	Возврат Окр((Сумма * ПараметрыТекущегоКурса.Курс * ПараметрыНовогоКурса.Кратность) / (ПараметрыНовогоКурса.Курс * ПараметрыТекущегоКурса.Кратность), 2);
КонецФункции

// Возвращает структуру с пустыми значениями.
//
// Возвращаемое значение: 
//   Структура - Параметры курса валюты.
//       * Валюта    - СправочникСсылка.Валюты
//       * Курс      - Число
//       * Кратность - Число
//
Функция СтруктураПараметровКурсаВалюты() Экспорт 
	
	СтруктураВозврата = Новый Структура;
	СтруктураВозврата.Вставить("Валюта", ПредопределенноеЗначение("Справочник.Валюты.ПустаяСсылка"));
	СтруктураВозврата.Вставить("Курс", 0);
	СтруктураВозврата.Вставить("Кратность", 0);
	
	Возврат СтруктураВозврата;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#КонецОбласти

