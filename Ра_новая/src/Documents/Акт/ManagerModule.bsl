Процедура ПечатьАкта(ТабДок, ПараметрКоманды) Экспорт 
	
	Макет = ПолучитьМакет("Акт");
				
		текНомер   = СокрЛП(ПараметрКоманды.Ссылка.Номер);
		// удаление ведущих нулей
		Пока Лев(текНомер, 1)="0" Цикл
			текНомер = Сред(текНомер, 2);
		КонецЦикла;
		
		ОбластьМакета       = Макет.ПолучитьОбласть("Заголовок");
		ОбластьМакета.Параметры.ТекстЗаголовка =  "Акт № " + текНомер
	                          + " от " + Формат(ПараметрКоманды.Ссылка.Дата, "ДФ='дд ММММ гггг'")+ " г.";
		ТабДок.Вывести(ОбластьМакета);
		
		ОбластьМакета       = Макет.ПолучитьОбласть("Поставщик");
		ОбластьМакета.Параметры.ПредставлениеПоставщика = ПараметрКоманды.Организация.Наименование;
		ТабДок.Вывести(ОбластьМакета);
		
		ОбластьМакета       = Макет.ПолучитьОбласть("Покупатель");
		ПредставлениеПолучателя = ПараметрКоманды.Контрагент.НаименованиеПолное;
		ОбластьМакета.Параметры.ПредставлениеПолучателя = ПредставлениеПолучателя;
		ТабДок.Вывести(ОбластьМакета);
		
		ОбластьМакета       = Макет.ПолучитьОбласть("ШапкаТаблицы");
		ТабДок.Вывести(ОбластьМакета);
		
		ОбластьМакета       = Макет.ПолучитьОбласть("Строка");
		сч=1;
		для Каждого стрТЧ из ПараметрКоманды.Товары цикл
			ОбластьМакета.параметры.НомерСтроки = Сч;
			ОбластьМакета.параметры.Товар 		= стрТЧ.Номенклатура;
			ОбластьМакета.параметры.Количество 	= стрТЧ.Количество;
			ОбластьМакета.параметры.ЕдиницаИзмерения = стрТЧ.Номенклатура.ЕдиницаИзмерения;
			//ОбластьМакета.параметры.Сумма 	= стрТЧ.Сумма+стрТЧ.СуммаНДС; 090920
			ОбластьМакета.параметры.Сумма 	= стрТЧ.Всего;
			ОбластьМакета.параметры.Цена 	= ОбластьМакета.параметры.Сумма/ОбластьМакета.параметры.Количество;
			
			ТабДок.Вывести(ОбластьМакета);
			сч=сч+1;
		КонецЦикла;
		
		Если ПараметрКоманды.Организация.СтавкаНДС=Перечисления.СтавкиНДС.БезНДС Тогда 
			БезНДС = Истина;
		иначе
			БезНДС = Ложь;
		КонецЕсли;	
		
		//СуммаДокумента = ПараметрКоманды.Товары.Итог("Сумма")+ПараметрКоманды.Товары.Итог("СуммаНДС"); 090920
		СуммаДокумента = ПараметрКоманды.Товары.Итог("Всего");
		
		ОбластьМакета       = Макет.ПолучитьОбласть("Итого");	
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
		
		ОбластьМакета       = Макет.ПолучитьОбласть("Подписи");
		ОбластьМакета.Параметры.Отпустил = "/"+ПолучениеСписков.ОтвественныхЛиц(ПараметрКоманды.Организация,Перечисления.ОтветственныеЛица.Руководитель,ПараметрКоманды.Дата).ФизическоеЛицо+"/";		
		ТабДок.Вывести(ОбластьМакета);

		ОбластьМакета       = Макет.ПолучитьОбласть("МП");
		ТабДок.Вывести(ОбластьМакета);
        
КонецПроцедуры	
	
Процедура ПечатьТОРГ2(ТабДок, ПараметрКоманды) Экспорт 
	Макет = ПолучитьМакет("ПФ_MXL_ТОРГ12_ru");
	
	ПредОрганизация = ОрганизацияПредставление(ПараметрКоманды.Организация); 
	ПредставлениеОрганизации = ПредОрганизация.Наименование+" "+ПредОрганизация.ИНН+"/"+ПредОрганизация.КПП
	+ПредОрганизация.ЮридическийАдрес+ПредОрганизация.НомерСчета+ПредОрганизация.Банк
	+ПредОрганизация.БИК+ПредОрганизация.КорреспондентскийСчет;
	
	ЗаказчикПредставление = КонтрагентПредставление(ПараметрКоманды.Контрагент);
	ПредставлениеГрузополучателя = ЗаказчикПредставление.Наименование+" "+ЗаказчикПредставление.ИНН+"/"+ЗаказчикПредставление.КПП
	+ЗаказчикПредставление.ЮридическийАдрес+ЗаказчикПредставление.НомерСчета+ЗаказчикПредставление.Банк
	+ЗаказчикПредставление.БИК+ЗаказчикПредставление.КорреспондентскийСчет;

	//ПредставлениеПоставщика = ЗаказчикПредставление.НаименованиеПолное+" "+ЗаказчикПредставление.ИНН+"/"+ЗаказчикПредставление.КПП
	//+ЗаказчикПредставление.ЮридическийАдрес+ЗаказчикПредставление.НомерСчета+ЗаказчикПредставление.Банк
	//+ЗаказчикПредставление.БИК+ЗаказчикПредставление.КорреспондентскийСчет;
	
	ОбластьМакета = Макет.ПолучитьОбласть("Шапка");
	ОбластьМакета.Параметры.ПредставлениеОрганизации 	= ПредставлениеОрганизации;
	ОбластьМакета.Параметры.ПредставлениеПодразделения 	= "";
	ОбластьМакета.Параметры.ПредставлениеГрузополучателя= ПредставлениеГрузополучателя;
	ОбластьМакета.Параметры.АдресДоставки 				= "";
	//ОбластьМакета.Параметры.ПредставлениеПоставщика	= ПредставлениеПоставщика;
	ОбластьМакета.Параметры.ПредставлениеПоставщика		= ПредставлениеОрганизации;
	ОбластьМакета.Параметры.ПредставлениеПлательщика 	= ПредставлениеГрузополучателя;
	ОбластьМакета.Параметры.Основание 					= ПараметрКоманды.Основание;
	ОбластьМакета.Параметры.ОрганизацияПоОКПО 			= ПараметрКоманды.Организация.ОКПО;	  
	ОбластьМакета.Параметры.ВидДеятельностиПоОКДП 		= "";
	ОбластьМакета.Параметры.ГрузополучательПоОКПО 		= ПараметрКоманды.Контрагент.ОКПО;
	ОбластьМакета.Параметры.ПоставщикПоОКПО 			= ПараметрКоманды.Организация.ОКПО;
	ОбластьМакета.Параметры.ПлательщикПоОКПО 			= ПараметрКоманды.Контрагент.ОКПО;
	ОбластьМакета.Параметры.ОснованиеНомер 				= ПараметрКоманды.Основание.Номер;
	ОбластьМакета.Параметры.ОснованиеДата 				= ПараметрКоманды.Основание.Дата;
	ОбластьМакета.Параметры.ТранспортнаяНакладнаяНомер 	= ПараметрКоманды.Номер;
	ОбластьМакета.Параметры.ТранспортнаяНакладнаяДата 	= ПараметрКоманды.Дата;
	ОбластьМакета.Параметры.ВидОперации 				= "";	
	ОбластьМакета.Параметры.НомерДокумента 				= ПараметрКоманды.Номер;
	ОбластьМакета.Параметры.ДатаДокумента 				= ПараметрКоманды.Дата;
	
	ТабДок.Вывести(ОбластьМакета);
	
	НомерСтраницы = 1;
	
	// Выводим многострочную часть докмента
	ОбластьЗаголовокТаблицы = Макет.ПолучитьОбласть("ЗаголовокТаб");
	ОбластьМакетаСтандарт   = Макет.ПолучитьОбласть("Строка");
	ОбластьИтоговПоСтранице = Макет.ПолучитьОбласть("ИтогоПоСтранице");
	ОбластьВсего            = Макет.ПолучитьОбласть("Всего");
	ОбластьПодвал           = Макет.ПолучитьОбласть("Подвал");
	
	//КоличествоСтрок = ПараметрКоманды.Товары.Количество();
	НомерСтроки= 0;
	ВыводШапки = 0;
	Для каждого стрТЧ из ПараметрКоманды.Товары Цикл
		НомерСтроки = НомерСтроки + 1;
		
		ОбластьМакетаСтандарт.Параметры.НомерСтроки 				= НомерСтроки;
		ОбластьМакетаСтандарт.Параметры.ПредставлениеНоменклатуры 	= стрТЧ.Номенклатура.Наименование; 
		ОбластьМакетаСтандарт.Параметры.НоменклатураКод			 	= ""; 
		ОбластьМакетаСтандарт.Параметры.ЕдиницаИзмеренияНаименование= стрТЧ.Номенклатура.ЕдиницаИзмерения.Наименование; 
		ОбластьМакетаСтандарт.Параметры.ЕдиницаИзмеренияКод		 	= "796";
		ОбластьМакетаСтандарт.Параметры.ВидУпаковки				 	= "";
		ОбластьМакетаСтандарт.Параметры.КоличествоВОдномМесте	 	= "";
		ОбластьМакетаСтандарт.Параметры.КоличествоМест			 	= стрТЧ.Количество;		
		ОбластьМакетаСтандарт.Параметры.МассаБрутто				 	= "";
		ОбластьМакетаСтандарт.Параметры.Количество				 	= стрТЧ.Количество;
		ОбластьМакетаСтандарт.Параметры.Цена				 		= стрТЧ.Цена;
		ОбластьМакетаСтандарт.Параметры.СуммаБезНДС				 	= стрТЧ.Сумма;
		ОбластьМакетаСтандарт.Параметры.СтавкаНДС				 	= стрТЧ.НДС;
		ОбластьМакетаСтандарт.Параметры.СуммаНДС				 	= стрТЧ.СуммаНДС;
		ОбластьМакетаСтандарт.Параметры.СуммаСНДС				 	= стрТЧ.Всего;
		
		Если НомерСтроки = 0 И ВыводШапки <> 2 Тогда
			ВыводШапки = 1;
		КонецЕсли;
		
		Если (НомерСтроки = 1 И ВыводШапки = 0) ИЛИ (НомерСтроки = 0 И ВыводШапки = 1) Тогда
			
			ВыводШапки = 2;
			
			СтруктураПараметров = Новый Структура;
			СтруктураПараметров.Вставить("НомерСтраницы", "Страница " + НомерСтраницы);
			ОбластьЗаголовокТаблицы.Параметры.Заполнить(СтруктураПараметров);
			ТабДок.Вывести(ОбластьЗаголовокТаблицы);
			
		КонецЕсли;
		ТабДок.Вывести(ОбластьМакетаСтандарт);
		
	КонецЦикла;
	
	ОбластьИтоговПоСтранице.Параметры.ИтогоКоличествоНаСтранице		= ПараметрКоманды.Товары.Итог("Количество");
	ОбластьИтоговПоСтранице.Параметры.ИтогоСуммаБезНДСНаСтранице	= ПараметрКоманды.Товары.Итог("Сумма");
	ОбластьИтоговПоСтранице.Параметры.ИтогоСуммаНДСНаСтранице		= ПараметрКоманды.Товары.Итог("СуммаНДС");
	ОбластьИтоговПоСтранице.Параметры.ИтогоСуммаСНДСНаСтранице		= ПараметрКоманды.Товары.Итог("Всего");
	ТабДок.Вывести(ОбластьИтоговПоСтранице);
	
	ОбластьВсего.Параметры.ИтогоКоличество	= ПараметрКоманды.Товары.Итог("Количество");
	ОбластьВсего.Параметры.ИтогоСуммаБезНДС	= ПараметрКоманды.Товары.Итог("Сумма");
	ОбластьВсего.Параметры.ИтогоСуммаНДС	= ПараметрКоманды.Товары.Итог("СуммаНДС");
	ОбластьВсего.Параметры.ИтогоСуммаСНДС	= ПараметрКоманды.Товары.Итог("Всего");
	ТабДок.Вывести(ОбластьВсего);

	ОбластьПодвал.Параметры.КоличествоПорядковыхНомеровЗаписейПрописью 	= ОбщегоНазначения.КоличествоПрописью(ПараметрКоманды.Товары.Количество());
	ОбластьПодвал.Параметры.ВсегоМестПрописью							= ОбщегоНазначения.КоличествоПрописью(ПараметрКоманды.Товары.Итог("Количество"));
	
	ФормСтрока = "Л = ru_RU; ДП = Истина";
	ПарПредмета="рубль, рубля, рублей, м, копейка, копейки, копеек, ж, 2";
	ПрописьЧисла = ЧислоПрописью(ПараметрКоманды.Товары.Итог("Всего"), ФормСтрока, ПарПредмета);			
	ОбластьПодвал.Параметры.СуммаПрописью								= ПрописьЧисла;
	
	Руководитель 		= ПолучениеСписков.ОтвественныхЛиц(ПараметрКоманды.Организация,Перечисления.ОтветственныеЛица.Руководитель,ПараметрКоманды.Дата);
	ГлавныйБухгалтер 	= ПолучениеСписков.ОтвественныхЛиц(ПараметрКоманды.Организация,Перечисления.ОтветственныеЛица.ГлавныйБухгалтер,ПараметрКоманды.Дата);

	Если ЗначениеЗаполнено(Руководитель) Тогда 
		ОбластьПодвал.Параметры.ФИОРуководителя = Руководитель.ФизическоеЛицо;
	иначе
		ОбластьПодвал.Параметры.ФИОРуководителя = "";
	КонецЕсли;	
	
	Если ЗначениеЗаполнено(ГлавныйБухгалтер) Тогда 
		ОбластьПодвал.Параметры.ФИОГлавБухгалтера	= ГлавныйБухгалтер.ФизическоеЛицо;
	Иначе
		ОбластьПодвал.Параметры.ФИОГлавБухгалтера	= "";
	КонецЕсли;

	ОбластьПодвал.Параметры.ДатаДокументаДень  = "";
	ОбластьПодвал.Параметры.ДатаДокументаМесяц = "";
	ОбластьПодвал.Параметры.ДатаДокументаГод   = "";
	
	ТабДок.Вывести(ОбластьПодвал);

КонецПроцедуры	

Процедура ПечатьКС2(ТабДокумент, ПараметрКоманды) Экспорт 
	
	Макет = ПолучитьМакет("ПФ_MXL_КС_2");
	
	ОбластьМакета = Макет.ПолучитьОбласть("Шапка");
	
	ИнвесторПредставление = КонтрагентПредставление(ПараметрКоманды.Инвестор);
	ПредставлениеИнвестор = ИнвесторПредставление.Наименование+" "+ИнвесторПредставление.ИНН+"/"+ИнвесторПредставление.КПП
	+ИнвесторПредставление.ЮридическийАдрес;
	
	ЗаказчикПредставление = КонтрагентПредставление(ПараметрКоманды.Контрагент);
	ПредставлениеЗаказчика = ЗаказчикПредставление.Наименование+" "+ЗаказчикПредставление.ИНН+"/"+ЗаказчикПредставление.КПП
	+ЗаказчикПредставление.ЮридическийАдрес;
	
	ПредОрганизация = ОрганизацияПредставление(ПараметрКоманды.Организация);  
	ПредставлениеОрганизации = ПредОрганизация.Наименование+" "+ПредОрганизация.ИНН+"/"+ПредОрганизация.КПП+ПредОрганизация.ЮридическийАдрес;
	
	Если ПараметрКоманды.СметнаяСтоимость>0 Тогда 
		ФормСтрока = "Л = ru_RU; ДП = Истина";
		ПарПредмета="рубль, рубля, рублей, м, копейка, копейки, копеек, ж, 2";
		ТекстСметнаяСтоимость = ЧислоПрописью(ПараметрКоманды.СметнаяСтоимость, ФормСтрока, ПарПредмета);
	Иначе 
		ТекстСметнаяСтоимость = "";
	КонецЕсли;
	
	ПараметрыШапки = Новый Структура; 
	ПараметрыШапки.Вставить("Инвестор", ПредставлениеИнвестор);
	ПараметрыШапки.Вставить("ПредставлениеЗаказчика", ПредставлениеЗаказчика);
	ПараметрыШапки.Вставить("ПредставлениеПодрядчика", ПредставлениеОрганизации); 
	ПараметрыШапки.Вставить("КонтрагентОКПО", ПараметрКоманды.Контрагент.ОКПО);
	ПараметрыШапки.Вставить("ОрганизацияОКПО", ПараметрКоманды.Организация.ОКПО);
	ПараметрыШапки.Вставить("Стройка", ПараметрКоманды.Стройка);
	ПараметрыШапки.Вставить("ДоговорКонтрагентаНомер", ПараметрКоманды.Договор.НомерДоговора);
	ПараметрыШапки.Вставить("ДоговорКонтрагентаДата", ПараметрКоманды.Договор.Дата); 
	ПараметрыШапки.Вставить("ДатаС", (ПараметрКоманды.Дата-(60*60*24*30)));
	ПараметрыШапки.Вставить("ДатаПо", ПараметрКоманды.Дата);
	ПараметрыШапки.Вставить("ТекстСметнаяСтоимость", ТекстСметнаяСтоимость);
	
	ЗаполнитьЗначенияСвойств(ОбластьМакета.Параметры, ПараметрыШапки);
	
	ТабДокумент.Вывести(ОбластьМакета);
	
	ОбластьМакета = Макет.ПолучитьОбласть("Строка");
	сч=1;

	для Каждого стрТЧ из ПараметрКоманды.Товары цикл
		ОбластьМакета.параметры.НомерСтроки = Сч;
		ОбластьМакета.параметры.Содержание 	= стрТЧ.Номенклатура;
		ОбластьМакета.параметры.БазоваяЕдИзм= стрТЧ.Номенклатура.ЕдиницаИзмерения;
		ОбластьМакета.параметры.Количество 	= стрТЧ.Количество;
		ОбластьМакета.параметры.Цена 		= стрТЧ.Всего/стрТЧ.Количество;
		ОбластьМакета.параметры.Сумма 		= стрТЧ.Всего;
			
		ТабДокумент.Вывести(ОбластьМакета);
		сч=сч+1;
	КонецЦикла;

	ОбластьМакета = Макет.ПолучитьОбласть("Подвал"); 
	
	СуммаДокумента = ПараметрКоманды.Товары.Итог("Всего"); 	
	ОбластьМакета.параметры.ИтогСуммы 		= СуммаДокумента; 
	
	СуммаНДС = ПараметрКоманды.Товары.Итог("СуммаНДС");
	
	Если СуммаНДС = 0 Тогда 
		ОбластьМакета.Параметры.ИтогНДС = "-";
	Иначе
		СуммаНДС = ПараметрКоманды.Товары.Итог("СуммаНДС");
		ОбластьМакета.Параметры.ИтогНДС = СуммаНДС;
	КонецЕсли;	
	
	ОбластьМакета.параметры.ИтогСуммыСНДС	= СуммаДокумента+СуммаНДС;
		
	ТабДокумент.Вывести(ОбластьМакета);

КонецПроцедуры	 

Процедура ПечатьКС3(ТабДокумент, ПараметрКоманды) Экспорт 
	
	Макет = ПолучитьМакет("ПФ_MXL_КС_3");
	
	ОбластьМакета = Макет.ПолучитьОбласть("Шапка"); 
	
	ИнвесторПредставление = КонтрагентПредставление(ПараметрКоманды.Инвестор);
	ПредставлениеИнвестор = ИнвесторПредставление.Наименование+" "+ИнвесторПредставление.ИНН+"/"+ИнвесторПредставление.КПП
	+ИнвесторПредставление.ЮридическийАдрес;
	
	ЗаказчикПредставление = КонтрагентПредставление(ПараметрКоманды.Контрагент);
	ПредставлениеЗаказчика = ЗаказчикПредставление.Наименование+" "+ЗаказчикПредставление.ИНН+"/"+ЗаказчикПредставление.КПП
	+ЗаказчикПредставление.ЮридическийАдрес;
	
	ПредОрганизация = ОрганизацияПредставление(ПараметрКоманды.Организация);  
	ПредставлениеОрганизации = ПредОрганизация.Наименование+" "+ПредОрганизация.ИНН+"/"+ПредОрганизация.КПП+ПредОрганизация.ЮридическийАдрес;
	
	Если ПараметрКоманды.СметнаяСтоимость>0 Тогда 
		ФормСтрока = "Л = ru_RU; ДП = Истина";
		ПарПредмета="рубль, рубля, рублей, м, копейка, копейки, копеек, ж, 2";
		ТекстСметнаяСтоимость = ЧислоПрописью(ПараметрКоманды.СметнаяСтоимость, ФормСтрока, ПарПредмета);
	Иначе 
		ТекстСметнаяСтоимость = "";
	КонецЕсли;
	
	ПараметрыШапки = Новый Структура; 
	ПараметрыШапки.Вставить("Инвестор", ПредставлениеИнвестор);
	ПараметрыШапки.Вставить("ПредставлениеЗаказчика", ПредставлениеЗаказчика);
	ПараметрыШапки.Вставить("ПредставлениеПодрядчика", ПредставлениеОрганизации); 
	ПараметрыШапки.Вставить("КонтрагентОКПО", ПараметрКоманды.Контрагент.ОКПО);
	ПараметрыШапки.Вставить("ОрганизацияОКПО", ПараметрКоманды.Организация.ОКПО);
	ПараметрыШапки.Вставить("Стройка", ПараметрКоманды.Стройка);
	ПараметрыШапки.Вставить("ДоговорКонтрагентаНомер", ПараметрКоманды.Договор.НомерДоговора);
	ПараметрыШапки.Вставить("ДоговорКонтрагентаДата", ПараметрКоманды.Договор.Дата); 
	ПараметрыШапки.Вставить("ДатаС", (ПараметрКоманды.Дата-(60*60*24*30)));
	ПараметрыШапки.Вставить("ДатаПо", ПараметрКоманды.Дата);
	ПараметрыШапки.Вставить("ТекстСметнаяСтоимость", ТекстСметнаяСтоимость);
	
	ЗаполнитьЗначенияСвойств(ОбластьМакета.Параметры, ПараметрыШапки);
	
	ТабДокумент.Вывести(ОбластьМакета);
	
	ОбластьМакета = Макет.ПолучитьОбласть("Строка");
	сч=1;

	для Каждого стрТЧ из ПараметрКоманды.Товары цикл
		ОбластьМакета.параметры.НомерСтроки = Сч;
		ОбластьМакета.параметры.Содержание 	= стрТЧ.Номенклатура;
		//ОбластьМакета.параметры.БазоваяЕдИзм= стрТЧ.Номенклатура.ЕдиницаИзмерения;
		//ОбластьМакета.параметры.Количество 	= стрТЧ.Количество;
		//ОбластьМакета.параметры.Цена 		= стрТЧ.Всего/стрТЧ.Количество;
		ОбластьМакета.параметры.Сумма 		= стрТЧ.Всего;
			
		ТабДокумент.Вывести(ОбластьМакета);
		сч=сч+1;
	КонецЦикла;

 КонецПроцедуры	
	
Функция ОрганизацияПредставление(Организация)
	
	ПредставлениеОрганизации = Новый Структура;
	ПредставлениеОрганизации.Вставить("Наименование",Организация.Наименование);
	ПредставлениеОрганизации.Вставить("ИНН","ИНН"+Организация.ИНН);
	ПредставлениеОрганизации.Вставить("КПП",Организация.КПП);
	ПредставлениеОрганизации.Вставить("ЮридическийАдрес",Организация.ЮридическийАдрес);
	ПредставлениеОрганизации.Вставить("НомерСчета","р/с "+Организация.БанковскийСчет.НомерСчета);
	ПредставлениеОрганизации.Вставить("Банк","в "+Организация.БанковскийСчет.Банк);
	ПредставлениеОрганизации.Вставить("БИК",Организация.БанковскийСчет.БИК);
	ПредставлениеОрганизации.Вставить("КорреспондентскийСчет","к/с "+Организация.БанковскийСчет.КорреспондентскийСчет);
		
   Возврат ПредставлениеОрганизации;
	
КонецФункции

Функция КонтрагентПредставление(Контрагент)
	
	
	ПредставлениеКонтрагент = Новый Структура;
	ПредставлениеКонтрагент.Вставить("Наименование",Контрагент.Наименование);
	ПредставлениеКонтрагент.Вставить("НаименованиеПолное",Контрагент.НаименованиеПолное);
	ПредставлениеКонтрагент.Вставить("ИНН","ИНН"+Контрагент.ИНН);
	ПредставлениеКонтрагент.Вставить("КПП",Контрагент.КПП);
	ПредставлениеКонтрагент.Вставить("ЮридическийАдрес",Контрагент.ЮридическийАдрес);
	ПредставлениеКонтрагент.Вставить("НомерСчета","р/с "+Контрагент.НомерРасчетногоСчета);
	ПредставлениеКонтрагент.Вставить("Банк","в "+Контрагент.Банк);
	ПредставлениеКонтрагент.Вставить("БИК",Контрагент.БИК);
	ПредставлениеКонтрагент.Вставить("КорреспондентскийСчет","к/с "+Контрагент.КорреспондентскийСчет);

	 Возврат ПредставлениеКонтрагент;

КонецФункции	