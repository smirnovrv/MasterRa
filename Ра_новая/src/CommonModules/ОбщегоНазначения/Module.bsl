// @strict-types


Процедура ОпределитьТекущегоПользователя(Знач ИмяПараметра, УстановленныеПараметры) Экспорт

	Если ИмяПараметра <> "ТекущийПользователь" Тогда
		Возврат;
	КонецЕсли;
	
	ТекПользователь = Справочники.Пользователи.НайтиПоНаименованию(ПользователиИнформационнойБазы.ТекущийПользователь().ПолноеИмя);
	
	Если Не ЗначениеЗаполнено(ТекПользователь) Тогда 
		Попытка 	
			ИдентификаторПользователяИБ = ПользователиИнформационнойБазы.ТекущийПользователь().УникальныйИдентификатор;
			
			Запрос = Новый Запрос;
			Запрос.Текст = "
			|ВЫБРАТЬ
			|	Пользователи.Ссылка КАК Ссылка
			|ИЗ
			|	Справочник.Пользователи КАК Пользователи
			|ГДЕ
			|	Пользователи.ИдентификаторПользователяИБ = &ИдентификаторПользователяИБ";
			
			Запрос.Параметры.Вставить("ИдентификаторПользователяИБ ", ИдентификаторПользователяИБ);
			
			Результат = Запрос.Выполнить();
			
			Если Результат.Пустой() Тогда
				ТекПользователь = СоздатьПользователя(ПользователиИнформационнойБазы,ИдентификаторПользователяИБ);
			Иначе
				Выборка = Результат.Выбрать();
				Пока Выборка.Следующий() Цикл 
					ТекПользователь = Выборка.Ссылка;
				КонецЦикла;	
			КонецЕсли;
		Исключение
			ТекПользователь = Справочники.Пользователи.НайтиПоНаименованию(ПользователиИнформационнойБазы.ТекущийПользователь().ПолноеИмя);
		КонецПопытки;
	КонецЕсли;
	
	ПараметрыСеанса.ТекущийПользователь = ТекПользователь;
	ПараметрыСеанса.ТекущаяОрганизация 	= ТекПользователь.Организация; 
КонецПроцедуры

Функция СоздатьПользователя(ПользователиИнформационнойБазы,ИдентификаторПользователяИБ)

	НовыйПользователь = Справочники.Пользователи.СоздатьЭлемент();
	НовыйПользователь.Код			= ПользователиИнформационнойБазы.ТекущийПользователь().Имя;
	НовыйПользователь.Наименование	= ПользователиИнформационнойБазы.ТекущийПользователь().ПолноеИмя;
	НовыйПользователь.ИдентификаторПользователяИБ = ИдентификаторПользователяИБ;
	НовыйПользователь.Записать();
	
	Возврат НовыйПользователь.Ссылка;
	
КонецФункции

Функция НайтиСотрудникаПоПользователю(Пользователь) Экспорт
	Сотрудник = Справочники.Сотрудники.НайтиПоРеквизиту("Пользователь",Пользователь);
	Возврат Сотрудник;
КонецФункции

Функция ЕстьНаряд(Номер) Экспорт	
	
	ЗапросНаряд = Новый Запрос;
	ЗапросНаряд.Текст = 
	"ВЫБРАТЬ
	|	НарядНаПроизводство.Номер
	|ИЗ
	|	Документ.НарядНаПроизводство КАК НарядНаПроизводство
	|ГДЕ
	|	НарядНаПроизводство.Номер = &Номер";
	
	ЗапросНаряд.УстановитьПараметр("Номер", Номер);
	
	РезультатНаряд = ЗапросНаряд.Выполнить();
	
	Возврат Не РезультатНаряд.Пустой();
	
КонецФункции

Функция ПолучитьПоРулону(НаДату,Рулон) Экспорт
	
	Стуктура = Новый Структура;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	РулоныОстатки.Материал КАК Материал
	|ИЗ
	|	РегистрНакопления.Рулоны.Остатки(
	|			&НаДату,
	|			Рулон = &Рулон
	|				И НЕ Материал = ЗНАЧЕНИЕ(СПравочник.Материалы.ПустаяСсылка)) КАК РулоныОстатки";
	
	Запрос.УстановитьПараметр("НаДату",НаДату); 
	Запрос.УстановитьПараметр("Рулон",Рулон);
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда 
		Стуктура.Вставить("МатериалОсновы",Справочники.МатериалОсновы.ПустаяСсылка());
		Стуктура.Вставить("Ширина","0");
		Стуктура.Вставить("Материал",Справочники.Материалы.ПустаяСсылка());
		Стуктура.Вставить("Цена",0);
		Стуктура.Вставить("Количество",0);
	иначе	
		ВыборкаДетальныеЗаписи = Результат.Выбрать();			
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл 
			Стуктура.Вставить("МатериалОсновы",ВыборкаДетальныеЗаписи.Материал.МатериалОсновы);
			Стуктура.Вставить("Ширина",ВыборкаДетальныеЗаписи.Материал.Ширина);
			Стуктура.Вставить("Материал",ВыборкаДетальныеЗаписи.Материал);
			Стуктура.Вставить("Цена",0);
			Стуктура.Вставить("Количество",0);
		КонецЦикла;
	КонецЕсли;
	
	Возврат Стуктура;
	
КонецФункции

Функция ВозможностиРедактированияДокумента(ДатаЗапрета) Экспорт
	
	ВозможностьРедактирования = Ложь;	
	
	Если РольДоступна("КоммерческийДиректор") Или РольДоступна("ПолныеПрава") Или РольДоступна("МастерМерч") Тогда 
		ВозможностьРедактирования = Истина;		
	иначе	
		Пользователь = ПараметрыСеанса.ТекущийПользователь;
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ДатаЗапретаРедактированияДанных.ДатаЗапрета КАК ДатаЗапрета
		|ИЗ
		|	РегистрСведений.ДатаЗапретаРедактированияДанных КАК ДатаЗапретаРедактированияДанных
		|ГДЕ
		|	ДатаЗапретаРедактированияДанных.Пользователь = &Пользователь
		|	И ДатаЗапретаРедактированияДанных.ДатаЗапрета < &ДатаЗапрета";
		
		Запрос.УстановитьПараметр("Пользователь", Пользователь);
		Запрос.УстановитьПараметр("ДатаЗапрета", ДатаЗапрета);
		
		РезультатЗапроса = Запрос.Выполнить();
		
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			ВозможностьРедактирования = Истина;
		КонецЦикла;
		
	КонецЕсли;
	
	Возврат ВозможностьРедактирования;
	
КонецФункции

Функция ПроверитьМатериалОсновы(Структура) Экспорт
	
	Совпадает = Ложь;
	
	МатериалОсновыПриход = Справочники.МатериалОсновы.ПустаяСсылка();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Рулоны.МатериалОсновы КАК МатериалОсновы
		|ИЗ
		|	РегистрНакопления.Рулоны КАК Рулоны
		|ГДЕ
		|	Рулоны.ВидДвижения = &ВидДвижения
		|	И Рулоны.Рулон = &Рулон";
	
	Запрос.УстановитьПараметр("ВидДвижения", ВидДвиженияНакопления.Приход);
	Запрос.УстановитьПараметр("Рулон", Структура.НомерРулона);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		МатериалОсновыПриход = ВыборкаДетальныеЗаписи.МатериалОсновы;
	КонецЦикла;

	Если Не МатериалОсновыПриход=Справочники.МатериалОсновы.ПустаяСсылка() Тогда 
		   Совпадает = МатериалОсновыПриход=Структура.МатериалОсновы;
	КонецЕсли;	
	
	Возврат Совпадает;
	
КонецФункции

Функция ПолучитьЦенуРулона(НомерРулона, Дата)  Экспорт 
	
	Цена = 0;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЦеныРулоновСрезПоследних.Цена КАК Цена
		|ИЗ
		|	РегистрСведений.ЦеныРулонов.СрезПоследних(&НаДату, Рулон = &Рулон) КАК ЦеныРулоновСрезПоследних";
	
	Запрос.УстановитьПараметр("НаДату", Дата);
	Запрос.УстановитьПараметр("Рулон", НомерРулона);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Цена = ВыборкаДетальныеЗаписи.Цена;
	КонецЦикла;
	
	Возврат Цена;

КонецФункции

Процедура ВыгрузкаВБухгалтерию() Экспорт
	МинусДень = 60*60*24;//1 день
	Обработка = Обработки.ВыгрузкаВБухгалерию_30_FTP.Создать();
	Обработка.Организация 			= Справочники.Организации.НайтиПоКоду("000000001");
	Обработка.Период.ДатаНачала 	= ТекущаяДата()-МинусДень;
	Обработка.Период.ДатаОкончания 	= ТекущаяДата();
	Обработка.ИмяФайла = "C:\Obmen_Ra\MasterRa.xml";
	Обработка.ВыгрузитьФайл();
КонецПроцедуры

Процедура ПередатьНаFtp(ПолноеИмяФайла,ИмяФайл) Экспорт
	
	Соединение = ПодключитьсяКFTPСерверу();
	  Соединение.УстановитьТекущийКаталог("/Ra");
	  	Соединение.Записать(ПолноеИмяФайла,// что записываем
		ИмяФайл// куда записываем
    );

КонецПроцедуры

Функция ПодключитьсяКFTPСерверу()
 
    Соединение = Новый FTPСоединение(
        "172.168.196.10", // адрес ftp сервера
        21, // порт сервера
        "User05_1c", // имя пользователя
        "SrvUser051C", // пароль пользователя
        Неопределено, // прокси не используется
        Истина, // пассивный режим работы
        0, // таймаут (0 - без ограничений)
        Неопределено // незащищенное соединение
    );
 
    // Для случаев, когда у ftp сервера нет возможности
    // обращаться к нам (мы находимся за межсетевым экраном)
    // следует использовать пассивный режим работы.
 
    Возврат Соединение;
 
КонецФункции

Функция ПолучитьОстатокРулона(НаДату,Рулон) Экспорт 
	
	Остаток = 0;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЕСТЬNULL(РулоныОстатки.КоличествоОстаток, 0) КАК КоличествоОстаток
		|ИЗ
		|	РегистрНакопления.Рулоны.Остатки(&НаДату, Рулон = &Рулон) КАК РулоныОстатки";
	
	Запрос.УстановитьПараметр("НаДату", НаДату);
	Запрос.УстановитьПараметр("Рулон", Рулон);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Остаток = ВыборкаДетальныеЗаписи.КоличествоОстаток;
	КонецЦикла;
	
	Возврат Остаток;
	
КонецФункции
	
Функция КоличествоПрописью(Количество) Экспорт

	ЦелаяЧасть   = Цел(Количество);
	ДробнаяЧасть = Окр(Количество - ЦелаяЧасть, 3);

	Если ДробнаяЧасть = Окр(ДробнаяЧасть,0) Тогда
		ПараметрыПрописи = ", , , , , , , , 0";

	ИначеЕсли ДробнаяЧасть = Окр(ДробнаяЧасть, 1) Тогда
		ПараметрыПрописи = "целая, целых, целых, ж, десятая, десятых, десятых, м, 1";

	ИначеЕсли ДробнаяЧасть = Окр(ДробнаяЧасть, 2) Тогда
		ПараметрыПрописи = "целая, целых, целых, ж, сотая, сотых, сотых, м, 2";

	Иначе
		ПараметрыПрописи = "целая, целых, целых, ж, тысячная, тысячных, тысячных, м, 3";

	КонецЕсли;

	Возврат ЧислоПрописью(Количество, ,ПараметрыПрописи);

КонецФункции // КоличествоПрописью()
