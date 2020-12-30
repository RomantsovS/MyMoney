﻿
#Область ПрограммныйИнтерфейс

// Шрифт, по размеру из настроек
// 
// Возвращаемое значение:
//   Шрифт
//
Функция ШрифтПриложения() Экспорт
	
	РазмерШрифта = Константы.РазмерШрифта.Получить();
	
	Если НЕ ЗначениеЗаполнено(РазмерШрифта) Тогда
		
		РазмерШрифтаПриложения = 8;
		
	ИначеЕсли РазмерШрифта = Перечисления.РазмерШрифта.Крупный Тогда
		
		РазмерШрифтаПриложения = 10;
		
	ИначеЕсли РазмерШрифта = Перечисления.РазмерШрифта.ОченьКрупный Тогда
		
		РазмерШрифтаПриложения = 11;
		
	ИначеЕсли РазмерШрифта = Перечисления.РазмерШрифта.Мелкий Тогда
		
		РазмерШрифтаПриложения = 7;
		
	КонецЕсли;
	
	ШрифтПриложения = Новый Шрифт(, РазмерШрифтаПриложения);
	
	Возврат ШрифтПриложения;
	
КонецФункции

Функция ЗачеркнутыйШрифтПриложения() Экспорт
	
	ШрифтПриложения = ШрифтПриложения();
	
	ЗачеркнутыйШрифт = Новый Шрифт(ШрифтПриложения,,,,,, Истина);
	Возврат ЗачеркнутыйШрифт;
	
КонецФункции

Функция ЖирныйШрифтПриложения() Экспорт
	
	ШрифтПриложения = ШрифтПриложения();
	
	ЖирныйШрифт = Новый Шрифт(ШрифтПриложения,,, Истина);
	Возврат ЖирныйШрифт;
	
КонецФункции

// Высота, по размеру из настроек
// 
// Возвращаемое значение:
//   Число
//
Функция ВысотаПоляНаименованиеТовара() Экспорт
	
	ВысотаПоля = ПолучитьЗначениеКонстанты("ВысотаПоляНаименованиеТовара");
	
	Возврат ВысотаПоля;
	
КонецФункции

// Форматная строка количественных полей из настроек (точность отображения количества).
// 
// Возвращаемое значение:
//   Строка
//
Функция ФорматКоличественныхПолей() Экспорт
	
	ФорматПолей = "ЧЦ=15; ЧДЦ=%ТочностьОтображенияКоличества%; ЧН=%ЧН%; ЧРД=.; ЧГ=0";
	
	ТочностьОтображенияКоличества = ПолучитьЗначениеКонстанты("ТочностьОтображенияКоличества");
	
	ФорматПолей = СтрЗаменить(ФорматПолей, "%ТочностьОтображенияКоличества%", ТочностьОтображенияКоличества);
	
	Если ТочностьОтображенияКоличества = 0 Тогда
		ЧН="0";
	Иначе
		ЧН="0.000";
		ЧН = Сред(ЧН, 1, ТочностьОтображенияКоличества + 2);
	КонецЕсли;
	
	ФорматПолей = СтрЗаменить(ФорматПолей, "%ЧН%", ЧН);
	
	Возврат ФорматПолей;
	
КонецФункции

// Форматная строка отображения даты: время и дата
// 
// Возвращаемое значение:
//   Строка
//
Функция ФорматДатыВремяИДата() Экспорт
	
	ФорматДаты = "ДФ='HH:mm:ss dd.MM.yyyy'";
	
	Возврат ФорматДаты;
	
КонецФункции

// Получение значения константы.
//
Функция ПолучитьЗначениеКонстанты(ИмяКонстанты) Экспорт
	
	Возврат Константы[ИмяКонстанты].Получить();
	
КонецФункции

#КонецОбласти