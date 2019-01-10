﻿////////////////////////////////////////////////////////////////////////////////
// Сокращенная версия одноименного модуля "Библиотеки стандартных подсистем"
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Разбивает строку на несколько строк по разделителю. Разделитель может иметь любую длину.
//
// Параметры:
//  Строка                 - Строка - текст с разделителями;
//  Разделитель            - Строка - разделитель строк текста, минимум 1 символ;
//  ПропускатьПустыеСтроки - Булево - признак необходимости включения в результат пустых строк.
//    Если параметр не задан, то функция работает в Режиме совместимости со своей предыдущей версией:
//     - Для разделителя-пробела пустые строки не включаются в результат, Для остальных разделителей пустые строки
//       включаются в результат.
//     - Если параметр Строка не содержит значащих символов или не содержит ни одного символа (пустая строка), то в
//       случае разделителя-пробела результатом функции будет массив, содержащий одно значение "" (пустая строка), а
//       при других разделителях результатом функции будет пустой массив.
//
//
// Возвращаемое значение:
//  Массив - массив строк.
//
// Примеры:
//  РазложитьСтрокуВМассивПодстрок(",один,,два,", ",") - Возвратит массив из 5 элементов, три из которых  - пустые строки;
//  РазложитьСтрокуВМассивПодстрок(",один,,два,", ",", Истина) - Возвратит массив из двух элементов;
//  РазложитьСтрокуВМассивПодстрок(" один   два  ", " ") - Возвратит массив из двух элементов;
//  РазложитьСтрокуВМассивПодстрок("") - Возвратит пустой массив;
//  РазложитьСтрокуВМассивПодстрок("",,Ложь) - Возвратит массив с одним элементом "" (пустой строкой);
//  РазложитьСтрокуВМассивПодстрок("", " ") - Возвратит массив с одним элементом "" (пустой строкой);
//
Функция РазложитьСтрокуВМассивПодстрок(Знач Строка, Знач Разделитель = ",", Знач ПропускатьПустыеСтроки = Неопределено) Экспорт
	
	Результат = Новый Массив;
	
	// Для обеспечения обратной совместимости
	Если ПропускатьПустыеСтроки = Неопределено Тогда
		ПропускатьПустыеСтроки = ?(Разделитель = " ", Истина, Ложь);
		Если ПустаяСтрока(Строка) Тогда 
			Если Разделитель = " " Тогда
				Результат.Добавить("");
			КонецЕсли;
			Возврат Результат;
		КонецЕсли;
	КонецЕсли;
	//
	
	Позиция = Найти(Строка, Разделитель);
	Пока Позиция > 0 Цикл
		Подстрока = Лев(Строка, Позиция - 1);
		Если Не ПропускатьПустыеСтроки Или Не ПустаяСтрока(Подстрока) Тогда
			Результат.Добавить(Подстрока);
		КонецЕсли;
		Строка = Сред(Строка, Позиция + СтрДлина(Разделитель));
		Позиция = Найти(Строка, Разделитель);
	КонецЦикла;
	
	Если Не ПропускатьПустыеСтроки Или Не ПустаяСтрока(Строка) Тогда
		Результат.Добавить(Строка);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции 

// Подставляет параметры в строку. Максимально возможное число параметров - 9.
// Параметры в строке задаются как %<номер параметра>. Нумерация параметров начинается с единицы.
//
// Параметры:
//  СтрокаПодстановки  – Строка – шаблон строки с параметрами (вхождениями вида "%ИмяПараметра");
//  Параметр<n>        - Строка - подставляемый параметр.
//
// Возвращаемое значение:
//  Строка   – текстовая строка с подставленными параметрами.
//
// Пример:
//  ПодставитьПараметрыВСтроку(НСтр("ru='%1 пошел в %2'"), "Вася", "Зоопарк") = "Вася пошел в Зоопарк".
//
Функция ПодставитьПараметрыВСтроку(Знач СтрокаПодстановки,
	Знач Параметр1, Знач Параметр2 = Неопределено, Знач Параметр3 = Неопределено,
	Знач Параметр4 = Неопределено, Знач Параметр5 = Неопределено, Знач Параметр6 = Неопределено,
	Знач Параметр7 = Неопределено, Знач Параметр8 = Неопределено, Знач Параметр9 = Неопределено) Экспорт
	
	ИспользоватьАльтернативныйАлгоритм = 
		Найти(Параметр1, "%")
		Или Найти(Параметр2, "%")
		Или Найти(Параметр3, "%")
		Или Найти(Параметр4, "%")
		Или Найти(Параметр5, "%")
		Или Найти(Параметр6, "%")
		Или Найти(Параметр7, "%")
		Или Найти(Параметр8, "%")
		Или Найти(Параметр9, "%");
		
	Если ИспользоватьАльтернативныйАлгоритм Тогда
		СтрокаПодстановки = ПодставитьПараметрыВСтрокуАльтернативныйАлгоритм(СтрокаПодстановки, Параметр1,
			Параметр2, Параметр3, Параметр4, Параметр5, Параметр6, Параметр7, Параметр8, Параметр9);
	Иначе
		СтрокаПодстановки = СтрЗаменить(СтрокаПодстановки, "%1", Параметр1);
		СтрокаПодстановки = СтрЗаменить(СтрокаПодстановки, "%2", Параметр2);
		СтрокаПодстановки = СтрЗаменить(СтрокаПодстановки, "%3", Параметр3);
		СтрокаПодстановки = СтрЗаменить(СтрокаПодстановки, "%4", Параметр4);
		СтрокаПодстановки = СтрЗаменить(СтрокаПодстановки, "%5", Параметр5);
		СтрокаПодстановки = СтрЗаменить(СтрокаПодстановки, "%6", Параметр6);
		СтрокаПодстановки = СтрЗаменить(СтрокаПодстановки, "%7", Параметр7);
		СтрокаПодстановки = СтрЗаменить(СтрокаПодстановки, "%8", Параметр8);
		СтрокаПодстановки = СтрЗаменить(СтрокаПодстановки, "%9", Параметр9);
	КонецЕсли;
	
	Возврат СтрокаПодстановки;
КонецФункции

// Формирует строку повторяющихся символов заданной длины.
//
// Параметры:
//  Символ      - Строка - символ, из которого будет формироваться строка.
//  ДлинаСтроки - Число  - требуемая длина результирующей строки.
//
// Возвращаемое значение:
//  Строка - строка, состоящая из повторяющихся символов.
//
Функция СформироватьСтрокуСимволов(Знач Символ, Знач ДлинаСтроки) Экспорт
	
	Результат = "";
	Для Счетчик = 1 По ДлинаСтроки Цикл
		Результат = Результат + Символ;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Дополняет строку символами слева или справа до заданной длины и возвращает ее.
// Незначащие символы слева и справа удаляются. По умолчанию функция дополняет строку символами "0" (ноль) слева.
//
// Параметры:
//  Строка      - Строка - исходная строка, которую необходимо дополнить символами;
//  ДлинаСтроки - Число  - требуемая результирующая длина строки;
//  Символ      - Строка - символ, которым необходимо дополнить строку;
//  Режим       - Строка - "Слева" или "Справа" - Режим добавления символов к исходной строке.
// 
// Возвращаемое значение:
//  Строка - строка, дополненная символами.
//
// Пример 1:
// Строка = "1234"; ДлинаСтроки = 10; Символ = "0"; Режим = "Слева"
// Возврат: "0000001234"
//
// Пример 2:
// Строка = " 1234  "; ДлинаСтроки = 10; Символ = "#"; Режим = "Справа"
// Возврат: "1234######"
//
Функция ДополнитьСтроку(Знач Строка, Знач ДлинаСтроки, Знач Символ = "0", Знач Режим = "Слева") Экспорт
	
	// длина символа не должна превышать единицы
	Символ = Лев(Символ, 1);
	
	// удаляем крайние пробелы слева и справа строки
	Строка = СокрЛП(Строка);
	
	КоличествоСимволовНадоДобавить = ДлинаСтроки - СтрДлина(Строка);
	
	Если КоличествоСимволовНадоДобавить > 0 Тогда
		
		СтрокаДляДобавления = СформироватьСтрокуСимволов(Символ, КоличествоСимволовНадоДобавить);
		
		Если ВРег(Режим) = "СЛЕВА" Тогда
			
			Строка = СтрокаДляДобавления + Строка;
			
		ИначеЕсли ВРег(Режим) = "СПРАВА" Тогда
			
			Строка = Строка + СтрокаДляДобавления;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Строка;
	
КонецФункции

// Очищает текст в формате HTML от тегов и возвращает неформатированный текст. 
//
// Параметры:
//  ИсходныйТекст - Строка - текст в формате HTML.
//
// Возвращаемое значение:
//  Строка - текст, очищенный от тегов, скриптов и заголовков.
//
Функция ИзвлечьТекстИзHTML(Знач ИсходныйТекст) Экспорт
	Результат = "";
	
	Текст = НРег(ИсходныйТекст);
	
	// отрезаем все что не body
	Позиция = Найти(Текст, "<body");
	Если Позиция > 0 Тогда
		Текст = Сред(Текст, Позиция + 5);
		ИсходныйТекст = Сред(ИсходныйТекст, Позиция + 5);
		Позиция = Найти(Текст, ">");
		Если Позиция > 0 Тогда
			Текст = Сред(Текст, Позиция + 1);
			ИсходныйТекст = Сред(ИсходныйТекст, Позиция + 1);
		КонецЕсли;
	КонецЕсли;
	
	Позиция = Найти(Текст, "</body>");
	Если Позиция > 0 Тогда
		Текст = Лев(Текст, Позиция - 1);
		ИсходныйТекст = Лев(ИсходныйТекст, Позиция - 1);
	КонецЕсли;
	
	// вырезаем скрипты
	Позиция = Найти(Текст, "<script");
	Пока Позиция > 0 Цикл
		ПозицияЗакрывающегоТега = Найти(Текст, "</script>");
		Если ПозицияЗакрывающегоТега = 0 Тогда
			// не найден закрывающий тег - вырезаем оставшийся текст.
			ПозицияЗакрывающегоТега = СтрДлина(Текст);
		КонецЕсли;
		Текст = Лев(Текст, Позиция - 1) + Сред(Текст, ПозицияЗакрывающегоТега + 9);
		ИсходныйТекст = Лев(ИсходныйТекст, Позиция - 1) + Сред(ИсходныйТекст, ПозицияЗакрывающегоТега + 9);
		Позиция = Найти(Текст, "<script");
	КонецЦикла;
	
	// вырезаем стили
	Позиция = Найти(Текст, "<style");
	Пока Позиция > 0 Цикл
		ПозицияЗакрывающегоТега = Найти(Текст, "</style>");
		Если ПозицияЗакрывающегоТега = 0 Тогда
			// не найден закрывающий тег - вырезаем оставшийся текст.
			ПозицияЗакрывающегоТега = СтрДлина(Текст);
		КонецЕсли;
		Текст = Лев(Текст, Позиция - 1) + Сред(Текст, ПозицияЗакрывающегоТега + 8);
		ИсходныйТекст = Лев(ИсходныйТекст, Позиция - 1) + Сред(ИсходныйТекст, ПозицияЗакрывающегоТега + 8);
		Позиция = Найти(Текст, "<style");
	КонецЦикла;
	
	// вырезаем все теги	
	Позиция = Найти(Текст, "<");
	Пока Позиция > 0 Цикл
		Результат = Результат + Лев(ИсходныйТекст, Позиция-1);
		Текст = Сред(Текст, Позиция + 1);
		ИсходныйТекст = Сред(ИсходныйТекст, Позиция + 1);
		Позиция = Найти(Текст, ">");
		Если Позиция > 0 Тогда
			Текст = Сред(Текст, Позиция + 1);
			ИсходныйТекст = Сред(ИсходныйТекст, Позиция + 1);
		КонецЕсли;
		Позиция = Найти(Текст, "<");
	КонецЦикла;
	Результат = Результат + ИсходныйТекст;
	
	Возврат СокрЛП(Результат);
КонецФункции

// Проверяет, содержит ли строка только цифры.
//
// Параметры:
//  СтрокаПроверки          - Строка - Строка Для проверки.
//  УчитыватьЛидирующиеНули - Булево - Флаг учета лидирующих нулей, Если Истина, то ведущие нули пропускаются.
//  УчитыватьПробелы        - Булево - Флаг учета пробелов, Если Истина, то пробелы при проверке игнорируются.
//
// Возвращаемое значение:
//   Булево - Истина - строка содержит только цифры или пустая, Ложь - строка содержит иные символы.
//
Функция ТолькоЦифрыВСтроке(Знач СтрокаПроверки, Знач УчитыватьЛидирующиеНули = Истина, Знач УчитыватьПробелы = Истина) Экспорт
	
	Если ТипЗнч(СтрокаПроверки) <> Тип("Строка") Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если Не УчитыватьПробелы Тогда
		СтрокаПроверки = СтрЗаменить(СтрокаПроверки, " ", "");
	КонецЕсли;
		
	Если ПустаяСтрока(СтрокаПроверки) Тогда
		Возврат Истина;
	КонецЕсли;
	
	Если Не УчитыватьЛидирующиеНули Тогда
		Позиция = 1;
		// Взятие символа за границей строки возвращает пустую строку.
		Пока Сред(СтрокаПроверки, Позиция, 1) = "0" Цикл
			Позиция = Позиция + 1;
		КонецЦикла;
		СтрокаПроверки = Сред(СтрокаПроверки, Позиция);
	КонецЕсли;
	
	// Если содержит только цифры, то в результате замен должна быть получена пустая строка.
	// Проверять при помощи ПустаяСтрока нельзя, так как в исходной строке могут быть пробельные символы.
	Возврат СтрДлина(
		СтрЗаменить( СтрЗаменить( СтрЗаменить( СтрЗаменить( СтрЗаменить(
		СтрЗаменить( СтрЗаменить( СтрЗаменить( СтрЗаменить( СтрЗаменить( 
			СтрокаПроверки, "0", ""), "1", ""), "2", ""), "3", ""), "4", ""), "5", ""), "6", ""), "7", ""), "8", ""), "9", "")
	) = 0;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Вставляет параметры в строку, учитывая, что в параметрах могут использоваться подстановочные слова %1, %2 и т.д.
Функция ПодставитьПараметрыВСтрокуАльтернативныйАлгоритм(Знач СтрокаПодстановки,
	Знач Параметр1, Знач Параметр2 = Неопределено, Знач Параметр3 = Неопределено,
	Знач Параметр4 = Неопределено, Знач Параметр5 = Неопределено, Знач Параметр6 = Неопределено,
	Знач Параметр7 = Неопределено, Знач Параметр8 = Неопределено, Знач Параметр9 = Неопределено)
	
	Результат = "";
	Позиция = Найти(СтрокаПодстановки, "%");
	Пока Позиция > 0 Цикл 
		Результат = Результат + Лев(СтрокаПодстановки, Позиция - 1);
		СимволПослеПроцента = Сред(СтрокаПодстановки, Позиция + 1, 1);
		ПодставляемыйПараметр = "";
		Если СимволПослеПроцента = "1" Тогда
			ПодставляемыйПараметр =  Параметр1;
		ИначеЕсли СимволПослеПроцента = "2" Тогда
			ПодставляемыйПараметр =  Параметр2;
		ИначеЕсли СимволПослеПроцента = "3" Тогда
			ПодставляемыйПараметр =  Параметр3;
		ИначеЕсли СимволПослеПроцента = "4" Тогда
			ПодставляемыйПараметр =  Параметр4;
		ИначеЕсли СимволПослеПроцента = "5" Тогда
			ПодставляемыйПараметр =  Параметр5;
		ИначеЕсли СимволПослеПроцента = "6" Тогда
			ПодставляемыйПараметр =  Параметр6;
		ИначеЕсли СимволПослеПроцента = "7" Тогда
			ПодставляемыйПараметр =  Параметр7
		ИначеЕсли СимволПослеПроцента = "8" Тогда
			ПодставляемыйПараметр =  Параметр8;
		ИначеЕсли СимволПослеПроцента = "9" Тогда
			ПодставляемыйПараметр =  Параметр9;
		КонецЕсли;
		Если ПодставляемыйПараметр = "" Тогда
			Результат = Результат + "%";
			СтрокаПодстановки = Сред(СтрокаПодстановки, Позиция + 1);
		Иначе
			Результат = Результат + ПодставляемыйПараметр;
			СтрокаПодстановки = Сред(СтрокаПодстановки, Позиция + 2);
		КонецЕсли;
		Позиция = Найти(СтрокаПодстановки, "%");
	КонецЦикла;
	Результат = Результат + СтрокаПодстановки;
	
	Возврат Результат;
КонецФункции
