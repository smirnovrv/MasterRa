// @strict-types


&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Не ЗначениеЗаполнено(Объект.ДатаСоздания) Тогда 
		Объект.ДатаСоздания = ТекущаяДатаСеанса();
	КонецЕсли;
	Элементы.ТипыВыполняемыхРабот.Видимость =  Объект.СтатусПрочий;
КонецПроцедуры

&НаКлиенте
Процедура СтатусПрочийПриИзменении(Элемент)
	Элементы.ТипыВыполняемыхРабот.Видимость =  Объект.СтатусПрочий;
КонецПроцедуры

&НаКлиенте
Процедура БезДоговораПриИзменении(Элемент)
	Если Объект.БезДоговора Тогда 
		СоздатьНовыйДоговор(Объект.Ссылка);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура СоздатьНовыйДоговор(Владелец)
	
	Если Не ЗначениеЗаполнено(Владелец) Тогда 
		Записать();
		Владелец = Объект.Ссылка;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Договоры.Ссылка
		|ИЗ
		|	Справочник.Договоры КАК Договоры
		|ГДЕ
		|	Договоры.Наименование ПОДОБНО &Наименование
		|	И Договоры.Владелец = &Владелец";

	Запрос.УстановитьПараметр("Наименование", "Без договора");
    Запрос.УстановитьПараметр("Владелец", Владелец);

	Результат = Запрос.Выполнить();

	Если Результат.Пустой() Тогда 
		новДоговор = Справочники.Договоры.СоздатьЭлемент();
		новДоговор.Владелец 	= Владелец;
		новДоговор.ВидДоговора 	= Перечисления.ВидыДоговоров.СПокупателем;
		новДоговор.ВидОплат 	= Перечисления.ВидыОплат.Предоплата;
		новДоговор.Дата         = ТекущаяДата();
		новДоговор.Наименование = "Без договора";
		новДоговор.Организация  = Справочники.Организации.НайтиПоКоду("000000001");
		новДоговор.Пролонгация  = Истина;
		новДоговор.СрокДействия = КонецГода(ТекущаяДата());
		новДоговор.Записать();
	КонецЕсли;
	
КонецПроцедуры	

&НаСервере
Процедура ЗаполнитьБрендыКонтрагентов()
	
	НоборЗаписей = РегистрыСведений.БрендыКонтрагентов.СоздатьНаборЗаписей();
	НоборЗаписей.Отбор.Контрагент.Установить(Объект.Ссылка);
	Для каждого стрБренды из Объект.Бренды цикл
		Запись = НоборЗаписей.Добавить();
		Запись.Бренд 		= стрБренды.Бренд;
		Запись.Контрагент 	= Объект.Ссылка;				
	КонецЦикла;
	НоборЗаписей.Записать();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	ЗаполнитьБрендыКонтрагентов();
КонецПроцедуры
