// @strict-types


Процедура ПечатьСчета(ТабДок, ПараметрКоманды) Экспорт 
	
	Макет = ПолучитьМакет("СчетЗаказ");
	Если ПараметрКоманды.Организация.ИНН="6679121870" Тогда
		ОбластьМакета	= Макет.ПолучитьОбласть("Лого");
	ИначеЕсли ПараметрКоманды.Организация.ИНН="6671320017" Тогда
		ОбластьМакета	= Макет.ПолучитьОбласть("ЛогоРа");
	ИначеЕсли ПараметрКоманды.Организация.ИНН="667472326758" Тогда
		ОбластьМакета	= Макет.ПолучитьОбласть("ЛогоИП");
	ИначеЕсли ПараметрКоманды.Организация.ИНН="6685200016" Тогда
	   ОбластьМакета	= Макет.ПолучитьОбласть("ЛогоМерч"); //01.06.22	   
	КонецЕсли;

	Если Не ОбластьМакета = Неопределено Тогда 
		ТабДок.Вывести(ОбластьМакета);
	КонецЕсли;
	
	ОбластьМакета	= Макет.ПолучитьОбласть("ЗаголовокСчета");
	ОбластьМакета.Параметры.БанкПолучателяПредставление 		= СокрЛП(ПараметрКоманды.БанковскийСчет.Банк);
	ОбластьМакета.Параметры.БИКБанкаПолучателя 					= ПараметрКоманды.БанковскийСчет.БИК;
	ОбластьМакета.Параметры.СчетБанкаПолучателяПредставление    = ПараметрКоманды.БанковскийСчет.КорреспондентскийСчет;
	ОбластьМакета.Параметры.ИНН 								= ПараметрКоманды.Организация.ИНН;
	ОбластьМакета.Параметры.КПП 								= ПараметрКоманды.Организация.КПП;
	ОбластьМакета.Параметры.СчетПолучателяПредставление 		= ПараметрКоманды.БанковскийСчет.НомерСчета;
	ОбластьМакета.Параметры.ПредставлениеПоставщика 			= ПараметрКоманды.Организация.Наименование;		
	ТабДок.Вывести(ОбластьМакета);
	
	текНомер   = СокрЛП(ПараметрКоманды.Ссылка.Номер);
	// удаление ведущих нулей
	Пока Лев(текНомер, 1)="0" Цикл
		текНомер = Сред(текНомер, 2);
	КонецЦикла;
	
	ОбластьМакета       = Макет.ПолучитьОбласть("Заголовок");
	ОбластьМакета.Параметры.ТекстЗаголовка =  "Счет на оплату № " + текНомер
	+ " от " + Формат(ПараметрКоманды.Ссылка.Дата, "ДФ='дд ММММ гггг'")+ " г.";
	ТабДок.Вывести(ОбластьМакета);
	
	ОбластьМакета       = Макет.ПолучитьОбласть("Поставщик");
	ОбластьМакета.Параметры.ПредставлениеПоставщика = "ИНН "+ПараметрКоманды.Организация.ИНН
	+" КПП "+ПараметрКоманды.Организация.КПП+", "+ПараметрКоманды.Организация.Наименование;
	ТабДок.Вывести(ОбластьМакета);
	
	ОбластьМакета       = Макет.ПолучитьОбласть("Покупатель");
	ПредставлениеПолучателя = "ИНН "+ПараметрКоманды.Контрагент.ИНН;
	Если ПараметрКоманды.Контрагент.ЮрФизЛицо = Перечисления.ЮрФизЛицо.ЮрЛицо Тогда  
		ПредставлениеПолучателя = ПредставлениеПолучателя +" КПП "+ПараметрКоманды.Контрагент.КПП;
	КонецЕсли;
	ПредставлениеПолучателя = ПредставлениеПолучателя+", "+ПараметрКоманды.Контрагент.НаименованиеПолное
	+", "+ПараметрКоманды.Контрагент.ЮридическийАдрес;
	ОбластьМакета.Параметры.ПредставлениеПолучателя = ПредставлениеПолучателя;
	ТабДок.Вывести(ОбластьМакета);
	
	ОбластьМакета       = Макет.ПолучитьОбласть("ШапкаТаблицы");
	ТабДок.Вывести(ОбластьМакета);
	
	ОбластьМакета       = Макет.ПолучитьОбласть("Строка");
	сч=1;
	для Каждого стрТЧ из ПараметрКоманды.Товары цикл
		ОбластьМакета.параметры.НомерСтроки = Сч;
		Если ЗначениеЗаполнено(стрТЧ.Содержание) Тогда 
			ОбластьМакета.параметры.Товар 		= стрТЧ.Содержание;
		иначе
			ОбластьМакета.параметры.Товар 		= стрТЧ.Номенклатура;
		КонецЕсли;
		ОбластьМакета.параметры.Количество 	= стрТЧ.Количество;
		ОбластьМакета.параметры.ЕдиницаИзмерения = стрТЧ.Номенклатура.ЕдиницаИзмерения;
		
		Если стрТЧ.Количество=0 Тогда 
			ОбластьМакета.параметры.Цена 	= 0;
		Иначе 
			ОбластьМакета.параметры.Цена 	= стрТЧ.Цена+(стрТЧ.СуммаНДС/стрТЧ.Количество);
		КонецЕсли;
		//ОбластьМакета.параметры.Сумма 	= стрТЧ.Сумма+стрТЧ.СуммаНДС;
		ОбластьМакета.параметры.Сумма 		= стрТЧ.Всего;     		
		
		ТабДок.Вывести(ОбластьМакета);
		сч=сч+1;
	КонецЦикла;
	
	Если ПараметрКоманды.Организация.СтавкаНДС=Перечисления.СтавкиНДС.БезНДС Тогда 
		БезНДС = Истина;
	иначе
		БезНДС = Ложь;
	КонецЕсли;	
		
	//СуммаДокумента = ПараметрКоманды.Товары.Итог("Сумма")+ПараметрКоманды.Товары.Итог("СуммаНДС");
	СуммаДокумента = ПараметрКоманды.Товары.Итог("Всего");

	ОбластьМакета  = Макет.ПолучитьОбласть("Итого");	
	ОбластьМакета.Параметры.Итого = ?(БезНДС, "Сумма без НДС:", "Итого:");
	ОбластьМакета.Параметры.Всего = СуммаДокумента;
	ТабДок.Вывести(ОбластьМакета);
	
	ОбластьМакета       = Макет.ПолучитьОбласть("ИтогоНДС");
	Если БезНДС Тогда
		ОбластьМакета.Параметры.НДС = "Без налога (НДС)";
		ОбластьМакета.Параметры.ВсегоНДС = "-";
	Иначе
		ОбластьМакета.Параметры.НДС = "В том числе НДС:";
		ОбластьМакета.Параметры.ВсегоНДС = ПараметрКоманды.Товары.Итог("СуммаНДС");
	КонецЕсли;	
	ТабДок.Вывести(ОбластьМакета);
	
	ОбластьМакета       = Макет.ПолучитьОбласть("СуммаПрописью");
	ОбластьМакета.Параметры.ИтоговаяСтрока ="Всего наименований " + ПараметрКоманды.Товары.Количество()
	+ ", на сумму " + Формат(СуммаДокумента,"ЧЦ=15;ЧДЦ=2") + " руб.";
	ФормСтрока = "Л = ru_RU; ДП = Истина";
	ПарПредмета="рубль, рубля, рублей, м, копейка, копейки, копеек, ж, 2";
	ПрописьЧисла = ЧислоПрописью(СуммаДокумента, ФормСтрока, ПарПредмета);		
	ОбластьМакета.Параметры.СуммаПрописью = ПрописьЧисла;	
	ТабДок.Вывести(ОбластьМакета);
	
	ОбластьМакета       = Макет.ПолучитьОбласть("ПодвалСчета");
	Если БезНДС Тогда
		ОбластьМакета.Параметры.УСН = "Организация применяет упрощенную систему налогообложения, счета-фактуры не выписываются";
	Иначе
		ОбластьМакета.Параметры.УСН = "";
	КонецЕсли;
	Руководитель 		= ПолучениеСписков.ОтвественныхЛиц(ПараметрКоманды.Организация,Перечисления.ОтветственныеЛица.Руководитель,ПараметрКоманды.Дата);
	ГлавныйБухгалтер 	= ПолучениеСписков.ОтвественныхЛиц(ПараметрКоманды.Организация,Перечисления.ОтветственныеЛица.ГлавныйБухгалтер,ПараметрКоманды.Дата);
	
	Если ЗначениеЗаполнено(Руководитель) Тогда 
		ОбластьМакета.Параметры.ФИОРуководитель = "/"+Руководитель.ФизическоеЛицо+"/";
	иначе
		ОбластьМакета.Параметры.ФИОРуководитель = "";
	КонецЕсли;	
	
	Если ЗначениеЗаполнено(ГлавныйБухгалтер) Тогда 
		ОбластьМакета.Параметры.ФИОглБухгалтер	= "/"+ГлавныйБухгалтер.ФизическоеЛицо+"/";
	Иначе
		ОбластьМакета.Параметры.ФИОглБухгалтер	= "";
	КонецЕсли;

	ТабДок.Вывести(ОбластьМакета);
	
	ОбластьМакета       = Макет.ПолучитьОбласть("Область3");
	ТабДок.Вывести(ОбластьМакета);
	
	ОбластьМакета       = Макет.ПолучитьОбласть("ПодписьМенеджер");
	ОбластьМакета.Параметры.Менеджер =  ПараметрКоманды.Отвественный;
	ТабДок.Вывести(ОбластьМакета);
	
КонецПроцедуры	

Процедура ПечатьСпецификации(ТабДок, ПараметрКоманды) Экспорт 
	
	Макет = ПолучитьМакет("Спецификация");
	
	Для Каждого стрПечати из ПараметрКоманды.Товары  Цикл
		
		ОбластьМакета       = Макет.ПолучитьОбласть("Заголовок");
		ОбластьМакета.Параметры.ТекстЗаголовка 	= "Спецификация номенклатуры: "+стрПечати.Номенклатура.Наименование;		
		ОбластьМакета.Параметры.ТекстЗаголовка2 = "Заявка "+стрПечати.КодЗаказа.Номер+" от "+Формат(стрПечати.КодЗаказа.Дата, "ДФ='дд ММММ гггг'");		
		ТабДок.Вывести(ОбластьМакета);
		
		ТекстЗаголовка = "Выходное изделие";
		ОбластьМакета = Макет.ПолучитьОбласть("ШапкаЗаголовок");
		ОбластьМакета.Параметры.ТекстЗаголовка = ТекстЗаголовка;
		ТабДок.Вывести(ОбластьМакета);
		
		ОбластьМакета = Макет.ПолучитьОбласть("Шапка");
		ТабДок.Вывести(ОбластьМакета);

		ОбластьМакета = Макет.ПолучитьОбласть("Строка");
		Для Каждого стрСпецификации из стрПечати.КодЗаказа.Спецификация цикл
			ОбластьМакета.Параметры.Заполнить(стрСпецификации);
			ОбластьМакета.Параметры.ЕдиницаИзмерения = стрСпецификации.Материал.ЕдиницаИзмерения;
			ТабДок.Вывести(ОбластьМакета);
		КонецЦикла;	
		
	КонецЦикла;
	
КонецПроцедуры	
