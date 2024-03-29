// @strict-types


&НаКлиенте
Процедура Отобрать(Команда)
	ЗаполнитьЗаказыНаСервере();	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьЗаказыНаСервере()
	
	Объект.Заказы.Очистить();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 		
		"ВЫБРАТЬ
		|	Заказы.Регистратор КАК Заказ,
		|	Заказы.Регистратор.Менеджер КАК Менеджер,
		|	Заказы.Регистратор.Контрагент КАК Плательщик,
		|	Заказы.Регистратор.Бренд КАК Бренд,
		|	Заказы.Регистратор.НаименованиеЗаказа КАК НазваниеЗаказа,
		|	Заказы.Регистратор.ИтогоЗаВесьЗаказ КАК ИтогоЗаВесьЗаказ,
		|	Заказы.Организация КАК Организация,
		|	Заказы.Регистратор.Дата КАК РегистраторДата,
		|	ВзаиморасчетыОстатки.СуммаОстаток КАК СуммаОстаток
		|ИЗ
		|	РегистрСведений.Заказы КАК Заказы
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ВзаиморасчетыПоЗаказам.Остатки КАК ВзаиморасчетыОстатки
		|		ПО Заказы.КодЗаказа = ВзаиморасчетыОстатки.КодЗаказа
		|ГДЕ
		|	Заказы.Счет = ЗНАЧЕНИЕ(Документ.Счет.ПустаяСсылка)
		|	И Заказы.Регистратор.Дата МЕЖДУ &начПериода И &конПериода
		|	И Заказы.Регистратор.НулеваяЦена = ЛОЖЬ
		|	И Заказы.Регистратор.ИтогоЗаВесьЗаказ > 0
		|	И ВзаиморасчетыОстатки.СуммаОстаток > 0";

	Запрос.УстановитьПараметр("начПериода",?(ЗначениеЗаполнено(Период.ДатаНачала),Период.ДатаНачала,Дата(1,1,1)));
	Запрос.УстановитьПараметр("конПериода",?(ЗначениеЗаполнено(Период.ДатаОкончания),Период.ДатаОкончания,КонецГода(ТекущаяДата())));
	
	Если ЗначениеЗаполнено(Менеджер) Тогда 
		Запрос.Текст = Запрос.Текст+" И Заказы.Регистратор.Менеджер = &Менеджер";
		Запрос.УстановитьПараметр("Менеджер",Менеджер);
	КонецЕсли;	
	
	Если ЗначениеЗаполнено(Контрагент) Тогда 
		Запрос.Текст = Запрос.Текст+" И Заказы.Регистратор.Контрагент = &ЮрЛицо"; //изм. 14.01.20
		Запрос.УстановитьПараметр("ЮрЛицо",Контрагент);
	КонецЕсли;	
	Запрос.Текст = Запрос.Текст+" УПОРЯДОЧИТЬ ПО РегистраторДата";

	Результат = Запрос.Выполнить();
	
  	УстановитьПривилегированныйРежим(Истина);
	ВыборкаДетальныеЗаписи = Результат.Выбрать();
	УстановитьПривилегированныйРежим(Ложь);
		
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		новСтрока = Объект.Заказы.Добавить();
		ЗаполнитьЗначенияСвойств(новСтрока,ВыборкаДетальныеЗаписи);
	КонецЦикла;

КонецПроцедуры	

&НаКлиенте
Процедура СоздатьСчета(Команда)
	Если Элементы.Заказы.ВыделенныеСтроки.Количество()>0 Тогда
		Парам = Новый Структура;
		
		ПервСтрока = Объект.Заказы.НайтиПоИдентификатору(Элементы.Заказы.ВыделенныеСтроки.Получить(0));
		Контр	= ПервСтрока.Плательщик;
		ЮЛ 		= ПервСтрока.Организация;

		Для Каждого стр из Элементы.Заказы.ВыделенныеСтроки Цикл	
			текСтрока = Объект.Заказы.НайтиПоИдентификатору(стр);
			Если Контр <> текСтрока.Плательщик Тогда
				Предупреждение("Груповая обработка применима только для счетов на одного заказчика",0,"Ошибка!");
				Возврат;
			КонецЕсли;
			Если ЮЛ <> текСтрока.Организация Тогда
				Предупреждение("Груповая обработка применима только для счетов от одной организации",0,"Ошибка!");
				Возврат;
			КонецЕсли;
		КонецЦикла;
		
		СсылкаОбъекта = СоздатьСчет();
		ОткрытьФорму("Документ.Счет.Форма.ФормаДокумента", Новый Структура("Ключ", СсылкаОбъекта));

	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция СоздатьСчет()	
	
	новСчет = Документы.Счет.СоздатьДокумент();
	новСчет.Дата            = ТекущаяДата();
	
	Для Каждого стр из Элементы.Заказы.ВыделенныеСтроки Цикл	
		текСтрока = Объект.Заказы.НайтиПоИдентификатору(стр);
		НовСчет.Договор 		= текСтрока.Заказ.Договор;
		новСчет.Отвественный	= текСтрока.Менеджер;
		новСчет.Организация 	= текСтрока.Организация;
		новСчет.Контрагент	 	= текСтрока.Плательщик;
		новСчет.БанковскийСчет 	= текСтрока.Организация.БанковскийСчет;
		новСчет.НДС_В_томЧисле  = текСтрока.Организация.НДС_В_томЧисле;

		ИтогоЗаВесьЗаказ = текСтрока.ИтогоЗаВесьЗаказ; //изм. 15.01.20
		ДанныеЗаполнения = текСтрока.Заказ; 
				
		новСтрока = новСчет.Товары.Добавить();			
		новСтрока.Количество 	= ДанныеЗаполнения.Тираж;
		новСтрока.КодЗаказа 	= ДанныеЗаполнения.ссылка;
		новСтрока.НДС       	= текСтрока.Организация.СтавкаНДС;
		новСтрока.Номенклатура 	= ДанныеЗаполнения.ИнформацияВСчете;
		новСтрока.СуммаНДС      = ?(новСтрока.НДС = Перечисления.СтавкиНДС.НДС20,ИтогоЗаВесьЗаказ*20/120,0);
		новСтрока.Сумма         = ИтогоЗаВесьЗаказ-новСтрока.СуммаНДС;
		новСтрока.Цена          = ?(новСтрока.Количество=0,0,новСтрока.Сумма/новСтрока.Количество);
		новСтрока.Всего         = ИтогоЗаВесьЗаказ;   
		
	КонецЦикла;
	новСчет.Записать();
	Возврат новСчет.Ссылка;
КонецФункции	
