
Процедура ПечатьСчетаФактуры(ТабДок, ПараметрКоманды) Экспорт 
	СчетФактура451 = Ложь;
	Если ПараметрКоманды.Дата>'20210701' Тогда
		Макет = ПолучитьМакет("ПФ_MXL_СчетФактура451"); 
		СчетФактура451 = Истина;	
	Иначе 	
		Макет = ПолучитьМакет("СчетФактура1137");
	КонецЕсли;

	ОбластьМакета = Макет.ПолучитьОбласть("Шапка");
	номер = ПараметрКоманды.Номер;
	Пока Лев(Номер, 1)="0" Цикл
		Номер = Сред(Номер, 2);
	КонецЦикла;
	
	//{+} ип_СРВ 02.12.21 
	ОбластьМакета.Параметры.Номер = номер; 
	ОбластьМакета.Параметры.Дата = Формат(ПараметрКоманды.Дата, "ДФ='дд ММММ гггг'")+ " г.";
	//{-} ип_СРВ

	ОбластьМакета.Параметры.ПредставлениеПоставщика = "Продавец: " + ПараметрКоманды.Организация.Наименование;
	ОбластьМакета.Параметры.АдресПоставщика			= ПараметрКоманды.Организация.ФактическийАдрес;
	ОбластьМакета.Параметры.ИННпоставщика           = "ИНН/КПП продавца: " +ПараметрКоманды.Организация.ИНН+"/"+ПараметрКоманды.Организация.КПП;
	Если ЗначениеЗаполнено(ПараметрКоманды.Основание.Грузоотправитель) Тогда 
		ОбластьМакета.Параметры.ПредставлениеГрузоотправителя =	"Грузоотправитель и его адрес: " +ПараметрКоманды.Основание.Грузоотправитель;
	иначе	
		ОбластьМакета.Параметры.ПредставлениеГрузоотправителя = "Грузоотправитель и его адрес: " +"---";
	КонецЕсли;
	Если ЗначениеЗаполнено(ПараметрКоманды.Основание.Грузополучатель) Тогда
		ОбластьМакета.Параметры.ПредставлениеГрузополучателя  = "Грузополучатель и его адрес: " +ПараметрКоманды.Основание.Грузополучатель;
	иначе	
		ОбластьМакета.Параметры.ПредставлениеГрузополучателя  = "Грузополучатель и его адрес: " +ПараметрКоманды.Основание.Контрагент.НаименованиеПолное+" "+ПараметрКоманды.Основание.Контрагент.ЮридическийАдрес;
	КонецЕсли;
	Строка_ПоДокументу = "К платежно-расчетному документу №_______________от__________";
	ОбластьМакета.Параметры.ПоДокументу                   = Строка_ПоДокументу;
	ОбластьМакета.Параметры.ПредставлениеПокупателя       = "Покупатель: "  + ПараметрКоманды.Контрагент.НаименованиеПолное;
	ОбластьМакета.Параметры.АдресПокупателя               = "Адрес: "       + ПараметрКоманды.Контрагент.ЮридическийАдрес;
	ОбластьМакета.Параметры.ИННПокупателя                 = "ИНН/КПП покупателя: "+ ПараметрКоманды.Контрагент.ИНН+"/"+ПараметрКоманды.Контрагент.КПП;	 

	ТабДок.Вывести(ОбластьМакета);
	
	ОбластьМакета = Макет.ПолучитьОбласть("ЗаголовокТаблицы");	
	ТабДок.Вывести(ОбластьМакета);
	
	ОбластьМакета = Макет.ПолучитьОбласть("Строка");

	ИтогоСуммаНДС = 0;
	ИтогоВсего    = 0;

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ДокументОснование", ПараметрКоманды.Основание);

	Запрос.Текст =
	 "ВЫБРАТЬ
	 |	АктТовары.Ссылка.Организация,
	 |	АктТовары.Ссылка.Организация КАК Поставщик,
	 |	АктТовары.Ссылка.Контрагент КАК Покупатель,
	 |	АктТовары.Ссылка.СуммаДокумента КАК Сумма,
	 |	АктТовары.Номенклатура КАК Товар,
	 |	СУММА(АктТовары.Количество) КАК Количество,
	 |	АктТовары.Цена,
	 |	АктТовары.Номенклатура.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	 |	СУММА(АктТовары.Сумма) КАК Стоимость,
	 |	СУММА(АктТовары.СуммаНДС) КАК СуммаНДС,
	 |	СУММА(АктТовары.Всего) КАК Всего,
	 |	АктТовары.НДС КАК СтавкаНДС,
	 |	""--"" КАК СтранаПроисхожденияКод,
	 |	""--"" КАК ПредставлениеСтраны,
	 |	""--"" КАК ПредставлениеГТД,
	 |	ВЫРАЗИТЬ(АктТовары.Номенклатура.Наименование КАК СТРОКА(1000)) КАК ТоварНаименование
	 |ИЗ
	 |	Документ.Акт.Товары КАК АктТовары
	 |ГДЕ
	 |	АктТовары.Ссылка = &ДокументОснование
	 |
	 |СГРУППИРОВАТЬ ПО
	 |	АктТовары.Цена,
	 |	АктТовары.Ссылка.Организация,
	 |	АктТовары.Ссылка.Контрагент,
	 |	АктТовары.Ссылка.СуммаДокумента,
	 |	АктТовары.Номенклатура,
	 |	АктТовары.Номенклатура.ЕдиницаИзмерения,
	 |	АктТовары.НДС,
	 |	ВЫРАЗИТЬ(АктТовары.Номенклатура.Наименование КАК СТРОКА(1000)),
	 |	АктТовары.Ссылка.Организация";
	 
	ВыборкаСтрокТовары = Запрос.Выполнить().Выбрать();
	
	ИтогоСуммаНДС = 0;
	ИтогоВсего    = 0;

	Пока ВыборкаСтрокТовары.Следующий() Цикл
		ОбластьМакета.Параметры.Заполнить(ВыборкаСтрокТовары);
		
		ИтогоСуммаНДС = ИтогоСуммаНДС + ВыборкаСтрокТовары.СуммаНДС;
		ИтогоВсего    = ИтогоВсего    + ВыборкаСтрокТовары.Всего;
      ТабДок.Вывести(ОбластьМакета);
	КонецЦикла;
   
	ОбластьМакета = Макет.ПолучитьОбласть("Итого");
	ОбластьМакета.Параметры.ИтогоСуммаНДС = ИтогоСуммаНДС;
	ОбластьМакета.Параметры.ИтогоВсего    = ИтогоВСего; 
	Если Не СчетФактура451 Тогда 
		ОбластьМакета.Параметры.ИтогоСтоимость= ПараметрКоманды.Основание.Товары.Итог("Сумма");  
	КонецЕсли;
	ТабДок.Вывести(ОбластьМакета);
	
	ОбластьМакета = Макет.ПолучитьОбласть("Подвал");
	Если СчетФактура451 Тогда
		ОбластьМакета.Параметры.ФИОРуководителя 		= "/"+ПолучениеСписков.ОтвественныхЛиц(ПараметрКоманды.Организация,Перечисления.ОтветственныеЛица.Руководитель,ПараметрКоманды.Дата).ФизическоеЛицо+"/";
		ОбластьМакета.Параметры.ФИОГлавногоБухгалтера	= "/"+ПолучениеСписков.ОтвественныхЛиц(ПараметрКоманды.Организация,Перечисления.ОтветственныеЛица.ГлавныйБухгалтер,ПараметрКоманды.Дата).ФизическоеЛицо+"/";	
	иначе	
		ОбластьМакета.Параметры.ФИОРуководитель = "/"+ПолучениеСписков.ОтвественныхЛиц(ПараметрКоманды.Организация,Перечисления.ОтветственныеЛица.Руководитель,ПараметрКоманды.Дата).ФизическоеЛицо+"/";
		ОбластьМакета.Параметры.ФИОглБухгалтер	= "/"+ПолучениеСписков.ОтвественныхЛиц(ПараметрКоманды.Организация,Перечисления.ОтветственныеЛица.ГлавныйБухгалтер,ПараметрКоманды.Дата).ФизическоеЛицо+"/";
	КонецЕсли;
	ТабДок.Вывести(ОбластьМакета);

КонецПроцедуры