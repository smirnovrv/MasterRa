// @strict-types


&НаКлиенте
Процедура ИмяФайлаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ВыборФайла(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ВыборФайла(Элемент, ПроверятьСуществование=Ложь)
	
	ДиалогФыбораФайла								=	Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	
	ДиалогФыбораФайла.Фильтр						=	"Файл данных (*.xml)|*.xml";
	ДиалогФыбораФайла.Заголовок						=	"Выберите файл";
	ДиалогФыбораФайла.ПредварительныйПросмотр		=	Ложь;
	ДиалогФыбораФайла.Расширение					=	"xml";
	ДиалогФыбораФайла.ИндексФильтра					=	0;
	ДиалогФыбораФайла.ПроверятьСуществованиеФайла	=	ПроверятьСуществование;
	
	Если ДиалогФыбораФайла.Выбрать() Тогда
		ИмяФайла = ДиалогФыбораФайла.ПолноеИмяФайла;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Коэффициент = 1;
КонецПроцедуры

&НаКлиенте
Процедура Выгрузить(Команда)
	
	ВыгрузитьНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ВыгрузитьНаСервере()
	
	ЗаписьXML = Новый ЗаписьXML;
	ЗаписьXML.ОткрытьФайл(ИмяФайла);
	
	ЗаписьXML.ЗаписатьОбъявлениеXML();
	ЗаписьXML.ЗаписатьНачалоЭлемента("Корневой");	
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СчетТовары.Номенклатура КАК Номенклатура,
	|	СчетТовары.Количество КАК Количество,
	|	СчетТовары.Цена КАК Цена,
	|	СчетТовары.Ссылка.Номер КАК Номер,
	|	СчетТовары.Ссылка.Дата КАК Дата,
	|	СчетТовары.Ссылка.Договор КАК Договор,
	|	СчетТовары.Ссылка.Контрагент КАК Контрагент,
	|	СчетТовары.Ссылка.Отвественный КАК Отвественный,
	|	СчетТовары.НомерСтроки КАК НомерСтроки,
	|	СчетТовары.КодЗаказа.Номер КАК КодЗаказа,
	|	СчетТовары.Сумма КАК Сумма,
	|	СчетТовары.СуммаНДС КАК СуммаНДС,
	|	СчетТовары.НДС КАК НДС,
	|	СчетТовары.Всего КАК Всего
	|ИЗ
	|	Документ.Счет.Товары КАК СчетТовары
	|ГДЕ
	|	СчетТовары.Ссылка.ПометкаУдаления = ЛОЖЬ
	|	И СчетТовары.Ссылка.Дата МЕЖДУ &НачПериода И &КонПериода
	|	И СчетТовары.Ссылка.Организация = &Организация";
	
	Запрос.УстановитьПараметр("КонПериода", КонецДня(Период.ДатаОкончания));
	Запрос.УстановитьПараметр("НачПериода", Период.ДатаНачала);
	Запрос.УстановитьПараметр("Организация", Организация);

	Результат = Запрос.Выполнить();
		
	ВыборкаДетальныеЗаписи = Результат.Выбрать();
			
	ЗаписьXML.ЗаписатьКомментарий("Элементы документа счет:");	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		ЗаписьXML.ЗаписатьНачалоЭлемента("ЭлементыСчета");	
		ЗаписьXML.ЗаписатьАтрибут("Дата",XMLСтрока(ВыборкаДетальныеЗаписи.Дата));	
		ЗаписьXML.ЗаписатьАтрибут("Номер",XMLСтрока(ВыборкаДетальныеЗаписи.Номер));
		
		ЗаписьXML.ЗаписатьАтрибут("Контрагент",ВыборкаДетальныеЗаписи.Контрагент.Наименование);
		ЗаписьXML.ЗаписатьАтрибут("КонтрагентИНН",ВыборкаДетальныеЗаписи.Контрагент.ИНН);
		ЗаписьXML.ЗаписатьАтрибут("КонтрагентКПП",ВыборкаДетальныеЗаписи.Контрагент.КПП);
		ЗаписьXML.ЗаписатьАтрибут("КонтрагентПолное",ВыборкаДетальныеЗаписи.Контрагент.НаименованиеПолное);
		ЗаписьXML.ЗаписатьАтрибут("КонтрагентАдрес",ВыборкаДетальныеЗаписи.Контрагент.ЮридическийАдрес);

		Если ЗначениеЗаполнено(ВыборкаДетальныеЗаписи.Контрагент.НомерРасчетногоСчета) Тогда 
			ЗаписьXML.ЗаписатьАтрибут("НомерРС",ВыборкаДетальныеЗаписи.Контрагент.НомерРасчетногоСчета);
			ЗаписьXML.ЗаписатьАтрибут("БИК",ВыборкаДетальныеЗаписи.Контрагент.БИК);
			ЗаписьXML.ЗаписатьАтрибут("НаименованиеРС","Расчетный в "+ВыборкаДетальныеЗаписи.Контрагент.Банк);
		КонецЕсли;	
		
		ЗаписьXML.ЗаписатьАтрибут("Договор",ВыборкаДетальныеЗаписи.Договор.Наименование);		
		ЗаписьXML.ЗаписатьАтрибут("ОрганизацияИНН",Организация.ИНН);
		ЗаписьXML.ЗаписатьАтрибут("ОрганизацияПрефикс",Организация.Префикс);
		ЗаписьXML.ЗаписатьАтрибут("Ответственный",ВыборкаДетальныеЗаписи.Отвественный.Наименование);
		                                                                 
		ЗаписьXML.ЗаписатьАтрибут("ТоварНомерСтроки",Строка(ВыборкаДетальныеЗаписи.НомерСтроки));
		ЗаписьXML.ЗаписатьАтрибут("Номенклатура",XMLСтрока(ВыборкаДетальныеЗаписи.Номенклатура));
		ЗаписьXML.ЗаписатьАтрибут("ТоварНоменклатура",ВыборкаДетальныеЗаписи.Номенклатура.Наименование);
		ЗаписьXML.ЗаписатьАтрибут("ТоварКоличество",Строка(ВыборкаДетальныеЗаписи.Количество));
		ЗаписьXML.ЗаписатьАтрибут("ТоварЦена",Строка(ВыборкаДетальныеЗаписи.Цена));
		ЗаписьXML.ЗаписатьАтрибут("ТоварСумма",Строка(ВыборкаДетальныеЗаписи.Сумма));
		ЗаписьXML.ЗаписатьАтрибут("ТоварСуммаНДС",Строка(ВыборкаДетальныеЗаписи.СуммаНДС));
		ЗаписьXML.ЗаписатьАтрибут("ТоварНДС",Строка(ВыборкаДетальныеЗаписи.НДС));
		ЗаписьXML.ЗаписатьАтрибут("ТоварВсего",Строка(ВыборкаДетальныеЗаписи.Всего));

		Попытка
			ЗаписьXML.ЗаписатьАтрибут("ТоварКодЗаказа",ВыборкаДетальныеЗаписи.КодЗаказа);
		Исключение
			ЗаписьXML.ЗаписатьАтрибут("ТоварКодЗаказа","");
		КонецПопытки;
		
		ЗаписьXML.ЗаписатьКонецЭлемента();
		
	КонецЦикла;	
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	АктТовары.Ссылка.Дата КАК ДатаАкта,
	|	АктТовары.Ссылка.Номер КАК НомерАкта,
	|	АктТовары.Номенклатура КАК НоменклатураАкта,
	|	АктТовары.Количество КАК КоличествоАкта,
	|	АктТовары.Цена КАК ЦенаАкта,
	|	АктТовары.Сумма КАК СуммаАкта,
	|	АктТовары.Ссылка.Основание.Номер КАК ОснованиеНомер,
	|	АктТовары.Ссылка.Контрагент КАК Контрагент,
	|	АктТовары.Ссылка.Договор КАК Договор,
	|	АктТовары.НомерСтроки КАК НомерСтроки,
	|	АктТовары.Ссылка КАК Акт,
	|	АктТовары.СуммаНДС КАК СуммаНДСАкт,
	|	АктТовары.НДС КАК НДСАкт,
	|	АктТовары.Всего КАК ВсегоАкта
	|ИЗ
	|	Документ.Акт.Товары КАК АктТовары
	|ГДЕ
	|	АктТовары.Ссылка.Дата МЕЖДУ &начДата И &конДата
	|	И АктТовары.Ссылка.Организация = &Организация
	|	И АктТовары.Ссылка.ПометкаУдаления = ЛОЖЬ";
	
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("конДата", КонецДня(Период.ДатаОкончания));
	Запрос.УстановитьПараметр("начДата", Период.ДатаНачала);
	
	Результат = Запрос.Выполнить();

	ВыборкаДетальныеЗаписи = Результат.Выбрать();
	
	ЗаписьXML.ЗаписатьКомментарий("Элементы документа акт:");	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		ЗаписьXML.ЗаписатьНачалоЭлемента("ЭлементыАкта");
		ЗаписьXML.ЗаписатьАтрибут("ДатаАкта",XMLСтрока(ВыборкаДетальныеЗаписи.ДатаАкта));	
		ЗаписьXML.ЗаписатьАтрибут("НомерАкта",ВыборкаДетальныеЗаписи.НомерАкта);
		ЗаписьXML.ЗаписатьАтрибут("КонтрагентАкта",ВыборкаДетальныеЗаписи.Контрагент.Наименование);
		ЗаписьXML.ЗаписатьАтрибут("КонтрагентАктаИНН",ВыборкаДетальныеЗаписи.Контрагент.ИНН);
		ЗаписьXML.ЗаписатьАтрибут("КонтрагентАктаКПП",ВыборкаДетальныеЗаписи.Контрагент.КПП);
		ЗаписьXML.ЗаписатьАтрибут("КонтрагентАктаПолное",ВыборкаДетальныеЗаписи.Контрагент.НаименованиеПолное);
		ЗаписьXML.ЗаписатьАтрибут("ОрганизацияИНН",Организация.ИНН);
		Если ЗначениеЗаполнено(ВыборкаДетальныеЗаписи.Контрагент.НомерРасчетногоСчета) Тогда 
			ЗаписьXML.ЗаписатьАтрибут("НомерРСАкта",ВыборкаДетальныеЗаписи.Контрагент.НомерРасчетногоСчета);
			ЗаписьXML.ЗаписатьАтрибут("БИКАкта",ВыборкаДетальныеЗаписи.Контрагент.БИК);
			ЗаписьXML.ЗаписатьАтрибут("НаименованиеРСАкта","Расчетный в "+ВыборкаДетальныеЗаписи.Контрагент.Банк);
		КонецЕсли;
		ЗаписьXML.ЗаписатьАтрибут("ДоговорКонтрагентаАкта",ВыборкаДетальныеЗаписи.Договор.Наименование);
		ЗаписьXML.ЗаписатьАтрибут("НомерСтроки",Строка(ВыборкаДетальныеЗаписи.НомерСтроки));
		ЗаписьXML.ЗаписатьАтрибут("Номенклатура",XMLСтрока(ВыборкаДетальныеЗаписи.НоменклатураАкта));
		ЗаписьXML.ЗаписатьАтрибут("НоменклатураАкта",ВыборкаДетальныеЗаписи.НоменклатураАкта.Наименование);
		ЗаписьXML.ЗаписатьАтрибут("КоличествоАкта",Строка(ВыборкаДетальныеЗаписи.КоличествоАкта));
		ЗаписьXML.ЗаписатьАтрибут("ЦенаАкта",Строка(ВыборкаДетальныеЗаписи.ЦенаАкта));
		ЗаписьXML.ЗаписатьАтрибут("СуммаАкта",Строка(ВыборкаДетальныеЗаписи.СуммаАкта));
		ЗаписьXML.ЗаписатьАтрибут("Основание",Строка(ВыборкаДетальныеЗаписи.ОснованиеНомер));
		ЗаписьXML.ЗаписатьАтрибут("СуммаНДСАкта",Строка(ВыборкаДетальныеЗаписи.СуммаНДСАкт));
		ЗаписьXML.ЗаписатьАтрибут("НДСАкта",Строка(ВыборкаДетальныеЗаписи.НДСАкт));
		ЗаписьXML.ЗаписатьАтрибут("ВсегоАкта",Строка(ВыборкаДетальныеЗаписи.ВсегоАкта));

		ЗаписьXML.ЗаписатьКонецЭлемента();	
		
		//Счет фактура выданный 
		Запрос_СФ = Новый Запрос;
		Запрос_СФ.Текст = 
		"ВЫБРАТЬ
		|	СчетФактураВыданный.Дата,
		|	СчетФактураВыданный.Номер
		|ИЗ
		|	Документ.СчетФактураВыданный КАК СчетФактураВыданный
		|ГДЕ
		|	СчетФактураВыданный.Основание = &Основание";
		
		Запрос_СФ.УстановитьПараметр("Основание", ВыборкаДетальныеЗаписи.Акт);
		
		РезультатЗапроса_СФ = Запрос_СФ.Выполнить();
		
		Выборка_СФ = РезультатЗапроса_СФ.Выбрать();
		
		Пока Выборка_СФ.Следующий() Цикл
			ЗаписьXML.ЗаписатьНачалоЭлемента("ЭлементыСчетФактура");
			ЗаписьXML.ЗаписатьАтрибут("ДатаСчетФактура",XMLСтрока(Выборка_СФ.Дата));	
			ЗаписьXML.ЗаписатьАтрибут("НомерСчетФактура",Выборка_СФ.Номер);	
			ЗаписьXML.ЗаписатьАтрибут("НомерОснования",ВыборкаДетальныеЗаписи.НомерАкта);	
			ЗаписьXML.ЗаписатьАтрибут("ДатаОснования",XMLСтрока(ВыборкаДетальныеЗаписи.ДатаАкта));	
			ЗаписьXML.ЗаписатьКонецЭлемента();	
		КонецЦикла;
		
	КонецЦикла;	

	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ПоступлениеТоваровУслугМатериалы.Ссылка КАК Ссылка,
	|	ПоступлениеТоваровУслугМатериалы.Количество КАК Количество,
	|	ПоступлениеТоваровУслугМатериалы.Цена КАК Цена,
	|	ПоступлениеТоваровУслугМатериалы.НДС КАК НДС,
	|	ПоступлениеТоваровУслугМатериалы.СуммаНДС КАК СуммаНДС,
	|	ПоступлениеТоваровУслугМатериалы.Сумма КАК Сумма,
	|	ПоступлениеТоваровУслугМатериалы.Ссылка.Дата КАК Дата,
	|	ПоступлениеТоваровУслугМатериалы.Ссылка.ПолучательТовара.ИНН КАК Организация,
	|	ПоступлениеТоваровУслугМатериалы.Ссылка.Номер КАК Номер,
	|	ПоступлениеТоваровУслугМатериалы.Ссылка.Поставщик КАК Контрагент,
	|	ПоступлениеТоваровУслугМатериалы.Ссылка.Договор КАК Договор,
	|	ПоступлениеТоваровУслугМатериалы.Материал.НоменклатураБухгалтерии КАК Номенклатура,
	|	ПоступлениеТоваровУслугМатериалы.Ссылка.Ответственный КАК Ответственный,
	|	ПоступлениеТоваровУслугМатериалы.Ссылка.ВхДата КАК ДатаВходящегоДокумента,
	|	ПоступлениеТоваровУслугМатериалы.Ссылка.ВхНомер КАК НомерВходящегоДокумента,
	|	"""" КАК Грузополучатель,
	|	ПоступлениеТоваровУслугМатериалы.Ссылка.Комментарий КАК Комментарий,
	|	ПоступлениеТоваровУслугМатериалы.НомерСтроки КАК НомерСтроки,
	|	"""" КАК Грузоотправитель,
	|	ПоступлениеТоваровУслугМатериалы.Всего КАК Всего
	|ИЗ
	|	Документ.ПоступлениеТоваровУслуг.Товары КАК ПоступлениеТоваровУслугМатериалы
	|ГДЕ
	|	ПоступлениеТоваровУслугМатериалы.Ссылка.ПометкаУдаления = ЛОЖЬ
	|	И ПоступлениеТоваровУслугМатериалы.Ссылка.Проведен = ИСТИНА
	|	И ПоступлениеТоваровУслугМатериалы.Ссылка.Дата МЕЖДУ &НачДата И &КонДата
	|	И ПоступлениеТоваровУслугМатериалы.Ссылка.ПолучательТовара = &Организация";

	Запрос.УстановитьПараметр("конДата", КонецДня(Период.ДатаОкончания));
	Запрос.УстановитьПараметр("начДата", Период.ДатаНачала);
	Запрос.УстановитьПараметр("Организация", Организация);

	Результат = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = Результат.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		ЗаписьXML.ЗаписатьНачалоЭлемента("ЭлементПоступления");
		ЗаписьXML.ЗаписатьАтрибут("Дата",XMLСтрока(ВыборкаДетальныеЗаписи.Дата));	
		ЗаписьXML.ЗаписатьАтрибут("Номер",XMLСтрока(ВыборкаДетальныеЗаписи.Номер));
		ЗаписьXML.ЗаписатьАтрибут("Ссылка",XMLСтрока(ВыборкаДетальныеЗаписи.Ссылка));
		ЗаписьXML.ЗаписатьАтрибут("Организация",XMLСтрока(ВыборкаДетальныеЗаписи.Организация));
		
		ЗаписьXML.ЗаписатьАтрибут("Контрагент",ВыборкаДетальныеЗаписи.Контрагент.Наименование);
		ЗаписьXML.ЗаписатьАтрибут("КонтрагентИНН",ВыборкаДетальныеЗаписи.Контрагент.ИНН);
		ЗаписьXML.ЗаписатьАтрибут("КонтрагентКПП",ВыборкаДетальныеЗаписи.Контрагент.КПП);
		ЗаписьXML.ЗаписатьАтрибут("КонтрагентПолное",ВыборкаДетальныеЗаписи.Контрагент.НаименованиеПолное);
		ЗаписьXML.ЗаписатьАтрибут("КонтрагентАдрес",ВыборкаДетальныеЗаписи.Контрагент.ЮридическийАдрес);
		ЗаписьXML.ЗаписатьАтрибут("ОрганизацияИНН",Организация.ИНН);
		
		Если ЗначениеЗаполнено(ВыборкаДетальныеЗаписи.Контрагент.НомерРасчетногоСчета) Тогда 
			ЗаписьXML.ЗаписатьАтрибут("НомерРС",ВыборкаДетальныеЗаписи.Контрагент.НомерРасчетногоСчета);
			ЗаписьXML.ЗаписатьАтрибут("БИК",ВыборкаДетальныеЗаписи.Контрагент.БИК);
			ЗаписьXML.ЗаписатьАтрибут("НаименованиеРС","Расчетный в "+ВыборкаДетальныеЗаписи.Контрагент.Банк);
		КонецЕсли;	
		
		ЗаписьXML.ЗаписатьАтрибут("Ответственный",ВыборкаДетальныеЗаписи.Ответственный.Наименование);
		ЗаписьXML.ЗаписатьАтрибут("ДатаВходящегоДокумента",XMLСтрока(ВыборкаДетальныеЗаписи.ДатаВходящегоДокумента));	
		ЗаписьXML.ЗаписатьАтрибут("НомерВходящегоДокумента",ВыборкаДетальныеЗаписи.НомерВходящегоДокумента);
		ЗаписьXML.ЗаписатьАтрибут("Грузоотправитель",ВыборкаДетальныеЗаписи.Грузоотправитель);
		ЗаписьXML.ЗаписатьАтрибут("Грузополучатель",ВыборкаДетальныеЗаписи.Грузополучатель);
		ЗаписьXML.ЗаписатьАтрибут("Комментарий",ВыборкаДетальныеЗаписи.Комментарий);
		ЗаписьXML.ЗаписатьАтрибут("Договор",ВыборкаДетальныеЗаписи.Договор.Наименование);
		
		ЗаписьXML.ЗаписатьАтрибут("НомерСтроки",XMLСтрока(ВыборкаДетальныеЗаписи.НомерСтроки));
		ЗаписьXML.ЗаписатьАтрибут("Номенклатура",XMLСтрока(ВыборкаДетальныеЗаписи.Номенклатура));
		ЗаписьXML.ЗаписатьАтрибут("НоменклатураИмя",ВыборкаДетальныеЗаписи.Номенклатура.Наименование);
		ЗаписьXML.ЗаписатьАтрибут("Количество",XMLСтрока(ВыборкаДетальныеЗаписи.Количество));
		ЗаписьXML.ЗаписатьАтрибут("Цена",XMLСтрока(ВыборкаДетальныеЗаписи.Цена));
		ЗаписьXML.ЗаписатьАтрибут("СтавкаНДС",XMLСтрока(ВыборкаДетальныеЗаписи.НДС));
		ЗаписьXML.ЗаписатьАтрибут("СуммаНДС",XMLСтрока(ВыборкаДетальныеЗаписи.СуммаНДС));
		ЗаписьXML.ЗаписатьАтрибут("Сумма",XMLСтрока(ВыборкаДетальныеЗаписи.Сумма));
		ЗаписьXML.ЗаписатьАтрибут("Всего",Строка(ВыборкаДетальныеЗаписи.Всего));
		
		ЗаписьXML.ЗаписатьКонецЭлемента();
	КонецЦикла;	
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СУММА(РулоныОбороты.КоличествоРасход) КАК РасходМП,
	|	РулоныОбороты.Материал.НоменклатураБухгалтерии КАК НаименованиеДляБУ,
	|	НАЧАЛОПЕРИОДА(АктТовары.Ссылка.Дата, ДЕНЬ) КАК ДатаАкта,
	|	РулоныОбороты.Материал КАК Материал,
	|	АктТовары.Ссылка.Номер КАК НомерАкта,
	|	АктТовары.КодЗаказа КАК КодЗаказа
	|ИЗ
	|	РегистрНакопления.Рулоны.Обороты(, , Регистратор, ) КАК РулоныОбороты
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.Акт.Товары КАК АктТовары
	|		ПО РулоныОбороты.Регистратор.Номер = АктТовары.КодЗаказа
	|ГДЕ
	|	РулоныОбороты.Регистратор ССЫЛКА Документ.НарядНаПроизводство
	|	И АктТовары.Ссылка.Проведен = ИСТИНА
	|	И АктТовары.Ссылка.Организация = &Организация
	|	И АктТовары.Ссылка.Дата МЕЖДУ &начДата И &конДата
	|
	|СГРУППИРОВАТЬ ПО
	|	РулоныОбороты.Материал.НоменклатураБухгалтерии,
	|	НАЧАЛОПЕРИОДА(АктТовары.Ссылка.Дата, ДЕНЬ),
	|	РулоныОбороты.Материал,
	|	АктТовары.Ссылка.Номер,
	|	АктТовары.КодЗаказа
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	СУММА(МатериалыОбороты.КоличествоРасход),
	|	МатериалыОбороты.Материал.НоменклатураБухгалтерии,
	|	НАЧАЛОПЕРИОДА(АктТовары.Ссылка.Дата, ДЕНЬ),
	|	МатериалыОбороты.Материал,
	|	АктТовары.Ссылка.Номер,
	|	АктТовары.КодЗаказа
	|ИЗ
	|	РегистрНакопления.Материалы.Обороты(, , Регистратор, ) КАК МатериалыОбороты
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.Акт.Товары КАК АктТовары
	|		ПО МатериалыОбороты.Регистратор.Номер = АктТовары.КодЗаказа
	|ГДЕ
	|	МатериалыОбороты.Регистратор ССЫЛКА Документ.НарядНаПроизводство
	|	И АктТовары.Ссылка.Проведен = ИСТИНА
	|	И АктТовары.Ссылка.Организация = &Организация
	|	И АктТовары.Ссылка.Дата МЕЖДУ &начДата И &конДата
	|
	|СГРУППИРОВАТЬ ПО
	|	МатериалыОбороты.Материал.НоменклатураБухгалтерии,
	|	НАЧАЛОПЕРИОДА(АктТовары.Ссылка.Дата, ДЕНЬ),
	|	МатериалыОбороты.Материал,
	|	АктТовары.Ссылка.Номер,
	|	АктТовары.КодЗаказа";
		
	Запрос.УстановитьПараметр("конДата", КонецДня(Период.ДатаОкончания));
	Запрос.УстановитьПараметр("начДата", Период.ДатаНачала);
	Запрос.УстановитьПараметр("Организация", Организация);
	
	Результат = Запрос.Выполнить();
	ТабличноеПоле1.Очистить();	
	ТабРезультат =  Результат.Выгрузить();
	ТабРезультат.Свернуть("НаименованиеДляБУ,ДатаАкта","РасходМП");
	
	ВыборкаДетальныеЗаписи = Результат.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		новСтрока = ТабличноеПоле1.Добавить();
		ЗаполнитьЗначенияСвойств(новСтрока,ВыборкаДетальныеЗаписи);
		Если Не ЗначениеЗаполнено(новСтрока.Материал) Тогда 
			 а =1;
		КонецЕсли;	
	КонецЦикла;	
	
	Для Каждого стрТЧ из ТабРезультат цикл
		ЗаписьXML.ЗаписатьНачалоЭлемента("Материал");
		ЗаписьXML.ЗаписатьАтрибут("ДатаАкта",XMLСтрока(стрТЧ.ДатаАкта));
		Если ЗначениеЗаполнено(стрТЧ.НаименованиеДляБУ) Тогда 
			ЗаписьXML.ЗаписатьАтрибут("НоменклатураДляБух",XMLСтрока(стрТЧ.НаименованиеДляБУ));
			ЗаписьXML.ЗаписатьАтрибут("Номенклатура",стрТЧ.НаименованиеДляБУ.Наименование);
		иначе
			ЗаписьXML.ЗаписатьАтрибут("НоменклатураДляБух","");
			ЗаписьXML.ЗаписатьАтрибут("Номенклатура","");
		КонецЕсли;
		РасходМП = стрТЧ.РасходМП*Коэффициент;
		ЗаписьXML.ЗаписатьАтрибут("РасходМП",XMLСтрока(РасходМП));
		ЗаписьXML.ЗаписатьКонецЭлемента();	
	КонецЦикла;	
	
	ЗаписьXML.ЗаписатьКонецЭлемента();
	ЗаписьXML.Закрыть();

КонецПроцедуры
