// @strict-types


&НаКлиенте
Процедура ИзменитьСтатус(массивЗадач,НовыйСтатус)	
	ИзменитьСтатусНаСервере(массивЗадач, НовыйСтатус);
	ОповеститьОбИзменении(Тип("ЗадачаСсылка.ЗадачаПользователя"));	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ИзменитьСтатусНаСервере(массивЗадач, новыйСтатус)
	Для Каждого текЗадача из массивЗадач Цикл 
		ЗадачаОбъект = текЗадача.ПолучитьОбъект(); 
		ЗадачаОбъект.Статус = новыйСтатус;
		Если новыйСтатус = Перечисления.СтатусыЗадач.Выполнено Тогда 
			 ЗадачаОбъект.Выполнена = Истина;
		КонецЕсли;	
		Попытка
			ЗадачаОбъект.Записать();
		Исключение
		КонецПопытки;
	КонецЦикла;	
КонецПроцедуры	

&НаКлиенте
Процедура СписокЗапланированоПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	массивЗадач = ПараметрыПеретаскивания.Значение;
	ИзменитьСтатус(массивЗадач,ПредопределенноеЗначение("Перечисление.СтатусыЗадач.Запланировано"));
КонецПроцедуры

&НаКлиенте
Процедура СписокНадоСделатьПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	массивЗадач = ПараметрыПеретаскивания.Значение;
	ИзменитьСтатус(массивЗадач,ПредопределенноеЗначение("Перечисление.СтатусыЗадач.НадоСделать"));
КонецПроцедуры

&НаКлиенте
Процедура СписокВыполняетсяПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	массивЗадач = ПараметрыПеретаскивания.Значение;
	ИзменитьСтатус(массивЗадач,ПредопределенноеЗначение("Перечисление.СтатусыЗадач.Выполняется"));
КонецПроцедуры

&НаКлиенте
Процедура СписокВыполненоПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	массивЗадач = ПараметрыПеретаскивания.Значение;
	ИзменитьСтатус(массивЗадач,ПредопределенноеЗначение("Перечисление.СтатусыЗадач.Выполнено"));
КонецПроцедуры

&НаКлиенте
Процедура СписокНаПроверкеПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	массивЗадач = ПараметрыПеретаскивания.Значение;
	ИзменитьСтатус(массивЗадач,ПредопределенноеЗначение("Перечисление.СтатусыЗадач.НаПроверке"));
КонецПроцедуры

&НаКлиенте
Процедура СписокОтложенаПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	массивЗадач = ПараметрыПеретаскивания.Значение;
	ИзменитьСтатус(массивЗадач,ПредопределенноеЗначение("Перечисление.СтатусыЗадач.Отложена"));
КонецПроцедуры

&НаКлиенте
Процедура СписокЗакрытаПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	массивЗадач = ПараметрыПеретаскивания.Значение;
	ИзменитьСтатус(массивЗадач,ПредопределенноеЗначение("Перечисление.СтатусыЗадач.Отменена"));
КонецПроцедуры

&НаКлиенте
Процедура СписокОтмененаПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	массивЗадач = ПараметрыПеретаскивания.Значение;
	ИзменитьСтатус(массивЗадач,ПредопределенноеЗначение("Перечисление.СтатусыЗадач.Закрыта"));
КонецПроцедуры

&НаКлиенте
Процедура ИсполнительПриИзменении(Элемент) 
	Если ЗначениеЗаполнено(Исполнитель) Тогда 
		УстановитьОтбор();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция РольДоступнаНаСервере(Роль)
	Возврат  РольДоступна(Роль)
КонецФункции	

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)  
	Исполнитель 					= ПараметрыСеанса.ТекущийПользователь;
	Автор                           = ПараметрыСеанса.ТекущийПользователь;
	
	Элементы.Исполнитель.Доступность= РольДоступнаНаСервере("РедактированиеЗадач");
	Элементы.Автор.Доступность= РольДоступнаНаСервере("РедактированиеЗадач");
	
	ОтборПоИсполнителю = Истина;
	
	УстановитьОтбор(); 
КонецПроцедуры

&НаКлиенте
Процедура ОтборПоИсполнителюПриИзменении(Элемент)
	ОтборПоАвтору = НЕ ОтборПоИсполнителю;
	УстановитьОтбор();
КонецПроцедуры

&НаКлиенте
Процедура ОтборПоАвторуПриИзменении(Элемент)
	ОтборПоИсполнителю = НЕ ОтборПоАвтору;
	УстановитьОтбор();
КонецПроцедуры

&НаСервере  
Процедура УстановитьОтбор() 	
	 УстановитьОтборСписку(СписокВыполнено);
	 УстановитьОтборСписку(СписокВыполняется);
	 УстановитьОтборСписку(СписокЗакрыта); 
	 УстановитьОтборСписку(СписокНадоСделать);
	 УстановитьОтборСписку(СписокНаПроверке);
	 УстановитьОтборСписку(СписокОтложена);
	 УстановитьОтборСписку(СписокОтменена);
КонецПроцедуры	

&НаСервере
Процедура УстановитьОтборСписку(текСписок) 
	
	текСписок.Отбор.Элементы.Очистить(); 
	
	Если ОтборПоИсполнителю Тогда
		Отбор = текСписок.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		Отбор.ВидСравнения 	= ВидСравненияКомпоновкиДанных.Равно;
		Отбор.ПравоеЗначение= Исполнитель;
		Отбор.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Испольнитель");
		Если Не РольДоступнаНаСервере("РедактированиеЗадач") Тогда
			Отбор.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Авто;
		КонецЕсли;
		Отбор.Использование = Истина;
	КонецЕсли;
	
	Если ОтборПоАвтору Тогда
		Отбор = текСписок.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		Отбор.ВидСравнения 	= ВидСравненияКомпоновкиДанных.Равно;
		Отбор.ПравоеЗначение= Автор;
		Отбор.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Автор");
		Если Не РольДоступнаНаСервере("РедактированиеЗадач") Тогда
			Отбор.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Авто;
		КонецЕсли;
		Отбор.Использование = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнительОчистка(Элемент, СтандартнаяОбработка)	
	  ИсполнительОчисткаНаСервере();
 КонецПроцедуры   
 
 &НаСервере
 Процедура ИсполнительОчисткаНаСервере()
	 
	 СписокВыполнено.Отбор.Элементы.Очистить();  
	 СписокВыполняется.Отбор.Элементы.Очистить();  
	 СписокЗакрыта.Отбор.Элементы.Очистить();  
	 СписокЗапланировано.Отбор.Элементы.Очистить();  
	 СписокНадоСделать.Отбор.Элементы.Очистить();  
	 СписокНаПроверке.Отбор.Элементы.Очистить();  
	 СписокОтложена.Отбор.Элементы.Очистить();  
	 СписокОтменена.Отбор.Элементы.Очистить();
	 
 КонецПроцедуры

&НаКлиенте
Процедура ПериодЗадачПриИзменении(Элемент)
	 УстановитьОтборСпискуПоДате(Элементы.СписокВыполнено);
	 УстановитьОтборСпискуПоДате(Элементы.СписокВыполняется);
	 УстановитьОтборСпискуПоДате(Элементы.СписокЗакрыта);
	 УстановитьОтборСпискуПоДате(Элементы.СписокНадоСделать);
	 УстановитьОтборСпискуПоДате(Элементы.СписокНаПроверке);
	 УстановитьОтборСпискуПоДате(Элементы.СписокОтложена);
	 УстановитьОтборСпискуПоДате(Элементы.СписокОтменена);	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтборСпискуПоДате(текСписок) 	
	текСписок.Период = ПериодЗадач;
	текСписок.Обновить();
КонецПроцедуры



