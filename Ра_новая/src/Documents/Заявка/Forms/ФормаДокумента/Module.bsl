// @strict-types

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Переделка = Ложь;
	Если Параметры.Ключ.Пустая() Тогда
		Если Параметры.Свойство("Переделка")=Ложь Тогда 
			Переделка = Ложь;
		Иначе 
			Переделка = Параметры.Переделка;
		КонецЕсли;	
		
		Объект.Статус	= Перечисления.Статусы.Вработе;
		Если Не ЗначениеЗаполнено(Параметры.ЗначениеКопирования) И Переделка=Ложь Тогда 		
			Объект.ВидРабот = Перечисления.ВидыРабот.СобственнаяПечатьНестандартныйРазмер; 
			Объект.СоздатьНаряд = Истина; 		
			Объект.Менеджер = ОбщегоНазначения.НайтиСотрудникаПоПользователю(ПараметрыСеанса.ТекущийПользователь);
			Элементы.ПричинаПеределки.Видимость = Ложь;
		ИначеЕсли ЗначениеЗаполнено(Параметры.ЗначениеКопирования) Тогда 
			Объект.Счет                     = Неопределено; 
			Объект.ЕстьНаряд    			= Ложь;
			Объект.СвязанныйЗаказ 			= Неопределено;
			Объект.ЕстьСвязанныйЗаказ 		= Ложь;
			Объект.СоздатьНаряд				= Ложь;
			Если Переделка=Ложь Тогда 
				Объект.СрокИзготовленияЗаказа 	= Неопределено;
			КонецЕсли;
			Объект.ДатаИВремяДоставки       = Неопределено;
			Объект.ДатаИВремяМонтажа		= Неопределено;
			Объект.ДатаИВремяСборки         = Неопределено;
			Объект.ИтогоЗаВесьЗаказ         = 0;
			Объект.ЦенаЗаКвМетр             = 0;
			Объект.ЦенаЗаЭкземпляр          = 0;
			Объект.МаржаЗаказа		        = 0;
		КонецЕсли;	
	КонецЕсли;
		
	ТелКонтактногоЛица = Объект.КонтактноеЛицо.Телефон;
	
	Если Строка(Объект.ФормаОплаты)="По сверке" Тогда 
		Элементы.Период.Видимость = Истина;
	Иначе 
		Элементы.Период.Видимость = Ложь;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Объект.Статус) Тогда 
		Объект.Статус 		= Перечисления.Статусы.Вработе;
		Модифицированность 	= Истина;
	КонецЕсли;
	
	Если Переделка Тогда 
		Элементы.СтраницаОсновное.ТолькоПросмотр    	= Истина;
		Элементы.СтраницаКоммерческая.ТолькоПросмотр	= Истина;
		Элементы.СтраницаДополнительно.ТолькоПросмотр	= Ложь; 
		Элементы.СтраницаЗатраты.ТолькоПросмотр			= Истина;
		Элементы.СтраницаМатериаловОсновы.ТолькоПросмотр= Истина;
		Элементы.СтраницаСпецификация.ТолькоПросмотр	= Истина;
		Элементы.СтраницаСвязанныеЗаявки.ТолькоПросмотр	= Истина;
		
		Объект.Переделка 			= Истина;
		Объект.Статус 				= Перечисления.Статусы.Вработе;
		Объект.ЕстьНаряд    		= Ложь;
		Объект.СвязанныйЗаказ 		= Неопределено;
		Объект.ЕстьСвязанныйЗаказ 	= Ложь;
		Объект.СоздатьНаряд			= Ложь;
	КонецЕсли;
	
	Если Объект.Статус = Перечисления.Статусы.Закрыт И Не РольДоступна("КоммерческийДиректор") Тогда   
		Если Объект.Статус = Перечисления.Статусы.Закрыт Тогда	
			Если Не РольДоступна("УУ") И Не РольДоступна("МастерМерч") Тогда
				ЭтаФорма.ТолькоПросмотр = Истина;
			КонецЕсли;
		иначе
			ЭтаФорма.ТолькоПросмотр = Ложь;
		КонецЕсли;	
	Иначе
		ЭтаФорма.ТолькоПросмотр = Ложь;	
	КонецЕсли;

	
	Элементы.ПоказатьВсё.Видимость = РольДоступна("ПолныеПрава");
	
	Если объект.Проведен И Не Объект.Статус = Перечисления.Статусы.Закрыт Тогда
		ИзмДокумент = ОбщегоНазначения.ВозможностиРедактированияДокумента(Объект.Дата);	
		ТолькоПросмотр 					= Не ИзмДокумент;
		Элементы.Номер.ТолькоПросмотр 	= Ложь; 
	КонецЕсли;	

	Элементы.Номер.ТолькоПросмотр = РольДоступна("Менеджер");
	
	УстановкаВидимости();

КонецПроцедуры

&НаКлиенте
Процедура ВидПродукцииНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ДанныеВыбора = ПолучениеСписков.ВидовПродукции(Объект.ВидРабот);
КонецПроцедуры

&НаСервере
Процедура ПечатнаяМашинаПриИзмененииНаСервере()
	Если Объект.ПечатнаяМашина.ВидМашины = Перечисления.ВидыПечатныхМашин.Интерьерная Тогда 
		Элементы.РазрешениеПечати.Видимость = Ложь;
	Иначе 
		Элементы.РазрешениеПечати.Видимость = Истина;
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура ПечатнаяМашинаПриИзменении(Элемент)
	ПечатнаяМашинаПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ВертикальИзображенияПриИзменении(Элемент)
	РасчитатьПлощадь();
КонецПроцедуры

Процедура РасчитатьПлощадь()
	Объект.ПлощадьИзображения 	= Объект.ВертикальИзображения*Объект.ГоризонтальИзображения;
	РасчитатьОбщуюПлощадьИзображения();
КонецПроцедуры

&НаКлиенте
Процедура ГоризонтальИзображенияПриИзменении(Элемент)
	РасчитатьПлощадь();
КонецПроцедуры

&НаСервере
Процедура  РасчитатьОбщуюПлощадьИзображения()
	 Объект.ОбщаяПлощадьИзображения = Объект.ПлощадьИзображения*Объект.Тираж
	*?(Объект.КоличествоСторон=0,1,Объект.КоличествоСторон);
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	Если Параметры.Ключ.Пустая() тогда
		Если ТекущийОбъект.Переделка Тогда 
			ТекущийОбъект.Номер = ОбщегоНазначенияВызовСервера.СформироватьНомерЗаявки("Переделка",ТекущийОбъект);
		иначе	
			ТекущийОбъект.Номер = ОбщегоНазначенияВызовСервера.СформироватьНомерЗаявки(Неопределено,Неопределено);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПриСменеСтраницыЗатратыНаСервере()
	
	Затраты.Очистить();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	РасходныйКассовыйОдерЗаказы.Ссылка КАК РКО,
		|	СУММА(РасходныйКассовыйОдерЗаказы.Сумма) КАК Сумма,
		|	РасходныйКассовыйОдерЗаказы.Ссылка.НаименованиеРасхода КАК НаименованиеРасхода
		|ИЗ
		|	Документ.РасходныйКассовыйОрдер.Заказы КАК РасходныйКассовыйОдерЗаказы
		|ГДЕ
		|	РасходныйКассовыйОдерЗаказы.Заявка = &Заявка
		|	И РасходныйКассовыйОдерЗаказы.Ссылка.Проведен
		|
		|СГРУППИРОВАТЬ ПО
		|	РасходныйКассовыйОдерЗаказы.Ссылка,
		|	РасходныйКассовыйОдерЗаказы.Ссылка.НаименованиеРасхода
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ПрочиеЗатратыЗаказы.Ссылка,
		|	СУММА(ПрочиеЗатратыЗаказы.Сумма),
		|	ПрочиеЗатратыЗаказы.Ссылка.НаименованиеРасхода
		|ИЗ
		|	Документ.ПрочиеЗатраты.Заказы КАК ПрочиеЗатратыЗаказы
		|ГДЕ
		|	ПрочиеЗатратыЗаказы.Заявка = &Заявка
		|	И ПрочиеЗатратыЗаказы.Ссылка.Проведен
		|	И ПрочиеЗатратыЗаказы.Ссылка.ДокументОплаты = ЗНАЧЕНИЕ(Документ.РасходныйКассовыйОрдер.ПустаяСсылка)
		|
		|СГРУППИРОВАТЬ ПО
		|	ПрочиеЗатратыЗаказы.Ссылка,
		|	ПрочиеЗатратыЗаказы.Ссылка.НаименованиеРасхода";
	
	Запрос.УстановитьПараметр("Заявка", Объект.Ссылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл 
		новСтрока = Затраты.Добавить();
		ЗаполнитьЗначенияСвойств(новСтрока,Выборка);
	КонецЦикла;	
	
	Объект.МаржаЗаказа = Объект.Стоимости.Итог("ЦенаДляКлиента")-Затраты.Итог("Сумма");
	
КонецПроцедуры

&НаСервере
Процедура ПриСменеСтраницыСвязанныеЗаявкиНаСервере()
	
	Объект.СвязанныеДокументы.Очистить();
	ДокументОбъект = РеквизитФормыВЗначение("Объект");
	
	//Может это уже связанная заявка
	текЗаявка 	= Объект.Ссылка; 
	поикЗаявка 	= ПолучитьСвязаннуюЗаявку_Вверх(текЗаявка);
	Если ЗначениеЗаполнено(поикЗаявка) Тогда 
		Пока поикЗаявка<>Документы.Заявка.ПустаяСсылка() Цикл
			НовСтрока = ДокументОбъект.СвязанныеДокументы.Добавить();
			НовСтрока.Докум  			= поикЗаявка; 
			НовСтрока.СвязаннаяЗаявка 	= текЗаявка;
			текЗаявка 	= поикЗаявка;
			поикЗаявка 	= ПолучитьСвязаннуюЗаявку_Вверх(текЗаявка);
		КонецЦикла;
	КонецЕсли;	
	
	//найдем связанную заявку для звязаного заказа
	Если ЗначениеЗаполнено(ДокументОбъект.СвязанныйЗаказ) Тогда
		Объект.СвязанныеДокументы.Очистить();
		//Строка связанные с этой заявкой
		НовСтрока = ДокументОбъект.СвязанныеДокументы.Добавить();
		НовСтрока.Докум 			= Объект.Ссылка;
		НовСтрока.СвязаннаяЗаявка 	= Объект.СвязанныйЗаказ;
		
		поикЗаявка = ПолучитьСвязаннуюЗаявку_Вниз(Объект.СвязанныйЗаказ);
		Пока поикЗаявка<>Документы.Заявка.ПустаяСсылка() Цикл
			НовСтрока = ДокументОбъект.СвязанныеДокументы.Добавить();
			НовСтрока.Докум 			= ДокументОбъект.СвязанныеДокументы.Получить(НовСтрока.НомерСтроки-2).СвязаннаяЗаявка;
			НовСтрока.СвязаннаяЗаявка 	= поикЗаявка;			
			поикЗаявка = ПолучитьСвязаннуюЗаявку_Вниз(поикЗаявка);			
		КонецЦикла;	
	КонецЕсли;
	ЗначениеВРеквизитФормы(ДокументОбъект, "Объект");
	
КонецПроцедуры

&НаСервере
Функция ПолучитьСвязаннуюЗаявку_Вниз(Заявка)
	
	СвязаннаяЗаявка = Документы.Заявка.ПустаяСсылка();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Заявка.СвязанныйЗаказ КАК СвязанныйЗаказ
	|ИЗ
	|	Документ.Заявка КАК Заявка
	|ГДЕ
	|	Заявка.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", Заявка);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если Не РезультатЗапроса.Пустой() Тогда 
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		ВыборкаДетальныеЗаписи.Следующий(); 
		СвязаннаяЗаявка = ВыборкаДетальныеЗаписи.СвязанныйЗаказ;
	КонецЕсли;

	Возврат СвязаннаяЗаявка;
	  
КонецФункции	

&НаСервере
Функция ПолучитьСвязаннуюЗаявку_Вверх(Заявка)
	
	СвязаннаяЗаявка = Документы.Заявка.ПустаяСсылка();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Заявка.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.Заявка КАК Заявка
	|ГДЕ
	|	Заявка.СвязанныйЗаказ = &СвязанныйЗаказ";
	
	Запрос.УстановитьПараметр("СвязанныйЗаказ", Заявка);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если Не РезультатЗапроса.Пустой() Тогда 
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		ВыборкаДетальныеЗаписи.Следующий(); 
		СвязаннаяЗаявка = ВыборкаДетальныеЗаписи.Ссылка;
	КонецЕсли;

	Возврат СвязаннаяЗаявка;
	  
КонецФункции
&НаКлиенте
Процедура ГруппаСтраницыПриСменеСтраницы(Элемент, ТекущаяСтраница)
	Если ТекущаяСтраница.Имя = "СтраницаЗатраты" Тогда 
		ПриСменеСтраницыЗатратыНаСервере();
		Элементы.тВсегоЗатрат.Заголовок = "Всего затрат: "+Затраты.Итог("Сумма");
	иначеЕсли ТекущаяСтраница.Имя = "СтраницаСвязанныеЗаявки" Тогда
		ПриСменеСтраницыСвязанныеЗаявкиНаСервере();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ЕстьСвязанныйЗаказПриИзменении(Элемент)
	Если Объект.ЕстьСвязанныйЗаказ Тогда 
		ОткрытьФорму("Документ.Заявка.ФормаВыбора",,,,,,Новый ОписаниеОповещения("ЕстьСвязанныйЗаказПриИзмененииПослеВыбора", ЭтотОбъект),РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	Иначе 
		Объект.СвязанныйЗаказ = Неопределено;		
	КонецЕсли;	
	Элементы.СвязанныйЗаказ.Видимость = Объект.ЕстьСвязанныйЗаказ;
КонецПроцедуры

&НаКлиенте
Процедура ЕстьСвязанныйЗаказПриИзмененииПослеВыбора(Результат, ДополнительныеПараметры) Экспорт
	Если Результат = Неопределено Тогда
		Объект.ЕстьСвязанныйЗаказ = Ложь;
	иначе		
		Если Результат = Объект.Ссылка Тогда 	
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = "Выбран текущий документ!
			|Выберите другой!";
			Сообщение.Сообщить();
			Объект.ЕстьСвязанныйЗаказ = Ложь;
		Иначе 
			Объект.СвязанныйЗаказ = Результат;
		КонецЕсли;	
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	массив = ОбщегоНазначенияВызовСервера.РазложитьСтрокуВМассивПодстрок(Объект.Номер,"-");
	записьРег = РегистрыСведений.ЗначениеНомераГруппы.СоздатьМенеджерЗаписи();
	записьРег.Префикс 	= массив.получить(0);
	записьРег.Номер	 	= массив.получить(1);
	записьРег.Группа 	= массив.получить(2);
	Попытка
		записьРег.Передел  = массив.получить(3);
	Исключение
		записьРег.Передел  = 0;
	КонецПопытки;
	записьРег.Записать();
		
КонецПроцедуры

&НаКлиенте
Процедура КоличествоСторонПриИзменении(Элемент)
	РасчитатьОбщуюПлощадьИзображения();
КонецПроцедуры

&НаКлиенте
Процедура ТиражПриИзменении(Элемент)
	РасчитатьОбщуюПлощадьИзображения();
КонецПроцедуры

&НаКлиенте
Процедура ПлощадьИзображенияПриИзменении(Элемент)
	РасчитатьОбщуюПлощадьИзображения();
КонецПроцедуры

&НаКлиенте
Процедура СтоимостиЦенаДляКлиентаПриИзменении(Элемент)
	Если Не Объект.НулеваяЦена Тогда 
		Объект.ИтогоЗаВесьЗаказ = Объект.Стоимости.Итог("ЦенаДляКлиента");
		РасчитатьЗаМетрКвИзображения();
		РасчитатьЗаЭкземплярИзображения();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура  РасчитатьЗаМетрКвИзображения()	
	Если Объект.ОбщаяПлощадьИзображения>0 и Объект.Стоимости.Количество()>0 Тогда //доб. 17.01.20
		Отбор = Новый Структура;
		Отбор.Вставить("Работы", Перечисления.РаботыСтоимости.ПечатьТиража);
		поиск = Объект.Стоимости.НайтиСтроки(Отбор);
		Если поиск.Количество()>0 Тогда
			текДанные = поиск.Получить(0); 
			Объект.ЦенаЗаКвМетр = текДанные.ЦенаДляКлиента/Объект.ОбщаяПлощадьИзображения;
		КонецЕсли;	 
		//Объект.ЦенаЗаКвМетр = Объект.ИтогоЗаВесьЗаказ/Объект.ОбщаяПлощадьИзображения;
	Иначе 
		Объект.ЦенаЗаКвМетр = 0;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура  РасчитатьЗаЭкземплярИзображения()	
	Если Объект.ОбщаяПлощадьИзображения>0 Тогда 
		Объект.ЦенаЗаЭкземпляр = Объект.ИтогоЗаВесьЗаказ/Объект.Тираж;
	Иначе 
		Объект.ЦенаЗаЭкземпляр = 0;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ИтогоЗаВесьЗаказПриИзменении(Элемент)
	РасчитатьЗаМетрКвИзображения();
	РасчитатьЗаЭкземплярИзображения();
КонецПроцедуры

&НаКлиенте
Процедура СтоимостиРаботыНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ДанныеВыбора = ПолучениеСписков.ВидовСтоимости(Объект.ВидРабот);
	
	Если Строка(Объект.ВидРабот)="Плотерная резка" Тогда 
		Если Объект.ВыборкаПлотернаяРезка = Ложь Тогда 
			Структура = Новый Структура;
			Структура.Вставить("СписокЗначений",ДанныеВыбора);
			Структура.Вставить("Вид","Выборка");
			инд = ПолучитьИндексДанныхВыбора(Структура);
			Если инд<>Неопределено Тогда 
				ДанныеВыбора.Удалить(инд);
			КонецЕсли;
		КонецЕсли;
		
		Если Объект.МонтажкаПлотернаяРезка = Ложь Тогда 
			Структура = Новый Структура;
			Структура.Вставить("СписокЗначений",ДанныеВыбора);
			Структура.Вставить("Вид","Монтажка");
			инд = ПолучитьИндексДанныхВыбора(Структура);
			Если инд<>Неопределено Тогда 
				ДанныеВыбора.Удалить(инд);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Функция ПолучитьИндексДанныхВыбора(Структура)
	
	инд = Неопределено;
	эл 	= Структура.СписокЗначений.НайтиПоЗначению(Перечисления.РаботыСтоимости[Структура.Вид]);
	инд = Структура.СписокЗначений.Индекс(эл);	
	
	Возврат инд;
	
КонецФункции	

&НаКлиенте
Процедура ФайлыИмяФайлаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ДиалогФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	ДиалогФайла.Фильтр = "Все файлы (*.*)|*.*";
	Если ДиалогФайла.Выбрать() Тогда
		Элементы.Файлы.ТекущиеДанные.ИмяФайла = СтрЗаменить(ДиалогФайла.ПолноеИмяФайла, ДиалогФайла.Каталог+"\", "");
		Модифицированность = Истина;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ЗатратыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	//текСтрока = Затраты.Получить(ВыбраннаяСтрока); ошибку вызывает
	текСтрока = Элементы.Затраты.ТекущиеДанные;
	Парам = новый Структура;
	Парам.вставить("Ключ",текСтрока.РКО);
	Если ТипЗнч(текСтрока.РКО) = Тип("ДокументСсылка.РасходныйКассовыйОрдер") Тогда 
		ОткрытьФорму("Документ.РасходныйКассовыйОрдер.ФормаОбъекта",парам);
	ИначеЕсли ТипЗнч(текСтрока.РКО) = Тип("ДокументСсылка.ПрочиеЗатраты") Тогда
		ОткрытьФорму("Документ.ПрочиеЗатраты.ФормаОбъекта",парам);
	КонецЕсли;		
КонецПроцедуры

&НаКлиенте
Процедура ФайлыИмяФайлаОткрытие(Элемент, СтандартнаяОбработка)
	ЗапуститьПриложение(Элементы.Файлы.ТекущиеДанные.ИмяФайла);
КонецПроцедуры

&НаКлиенте
Процедура КонтактноеЛицоПриИзменении(Элемент)
	Попытка
		ТелКонтактногоЛица = ПолучитьТелефонКонтактногоЛица(Объект.КонтактноеЛицо);
	Исключение
		ТелКонтактногоЛица = "";
	КонецПопытки;
КонецПроцедуры

&НаСервере
Функция ПолучитьТелефонКонтактногоЛица(КонтактноеЛицо)
	Возврат КонтактноеЛицо.Телефон;
КонецФункции

&НаКлиенте
Процедура ФормаОплатыПриИзменении(Элемент)
	Если Строка(Объект.ФормаОплаты)="По сверке" Тогда 
		Элементы.Период.Видимость = Истина;
	Иначе 
		Элементы.Период.Видимость = Ложь;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура АдресНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ДанныеВыбора = ПолучениеСписков.АдресовДоставкиПоКонтрагенту(Объект.Контрагент);
КонецПроцедуры

&НаКлиенте
Процедура ВидПродукцииОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	Если Строка(ВыбранноеЗначение) = "Цветопроба" Тогда 
		Объект.ГоризонтальИзображения 	= 1;
		Объект.ВертикальИзображения		= 0.3;
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	Если Не ЗначениеЗаполнено(ТелКонтактногоЛица) Тогда 
			Сообщить("Поле ""Телефон контактного лица"" не заполнено");
		  Отказ = Истина;
	  КонецЕсли;
	  Если Объект.Монтажники.Количество()>0 Тогда 
		  Объект.МонтажникиСтрокой = "";
		  Для Каждого стрТЧ Из Объект.Монтажники Цикл
			  Если Объект.МонтажникиСтрокой = "" Тогда 
			    Объект.МонтажникиСтрокой = Строка(стрТЧ.Монтажник)+"-"+Строка(стрТЧ.Ставка)+";";
			иначе
				Объект.МонтажникиСтрокой = Объект.МонтажникиСтрокой+" "+Строка(стрТЧ.Монтажник)+"-"+Строка(стрТЧ.Ставка)+";";
			КонецЕсли;
		  КонецЦикла;	  
	  КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура КонтрагентНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	Если ЗначениеЗаполнено(Объект.Бренд) Тогда
		СтандартнаяОбработка = Ложь;
		ДанныеВыбора = ПолучениеСписков.КонтрагентовПоБренду(Объект.Бренд);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьВсёПриИзменении(Элемент)
	Если Объект.ПоказатьВсё Тогда 
		Для Каждого Элем из Элементы Цикл
			Попытка 
				Элем.Видимость = Истина;
			Исключение
			КонецПопытки;
		КонецЦикла;	
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура ВидРабот1ПриИзменении(Элемент)
	УстановкаВидимости();
КонецПроцедуры

&НаСервере
Процедура УстановкаВидимости()
	//17 видов работ 
	Элементы.ПричинаПеределки.Видимость 			= Объект.Переделка;
	Элементы.ОбщееКоличествоПогонныхМетров.Видимость= Ложь; //Кроме 3,15
	Элементы.СтраницаМонтажники.Видимость   		= Ложь; 
	
	Если Объект.ВидРабот = Перечисления.ВидыРабот.ПлотернаяРезка Тогда  //8
		Элементы.ГруппаПлотернаяРезка.Видимость 		= Истина;
		Элементы.ДатаИВремяМонтажа.Видимость            = Истина;
		Элементы.ДатаИВремяСборки.Видимость 			= Истина;
	Иначе
		Элементы.ГруппаПлотернаяРезка.Видимость 		= Ложь;
		Элементы.ДатаИВремяМонтажа.Видимость            = Ложь;
		Элементы.ДатаИВремяСборки.Видимость 			= Ложь;
	КонецЕсли;	
	
	Если Объект.ВидРабот = Перечисления.ВидыРабот.СобственнаяПечатьНестандартныйРазмер Тогда //13
		Элементы.Период.Видимость = Истина;
	Иначе 
		Элементы.Период.Видимость = Ложь; 
	КонецЕсли;
	
	Если Объект.ВидРабот = Перечисления.ВидыРабот.СобственнаяПечатьЦветопроба Тогда //14
		Элементы.ЦветопробаКЗаказу.Видимость = Истина;
	Иначе 
		Элементы.ЦветопробаКЗаказу.Видимость = Ложь; 
	КонецЕсли;

	Если Объект.ВидРабот = Перечисления.ВидыРабот.Монтаж Тогда //5 
		Элементы.ДатаИВремяМонтажа.Видимость 	= Истина;
		Элементы.ДатаИВремяДоставки.Видимость	= Ложь;
		Элементы.ДатаИВремяСборки.Видимость 	= Ложь;
		Элементы.СтраницаМонтажники.Видимость   = Истина;
	ИначеЕсли Объект.ВидРабот = Перечисления.ВидыРабот.Сборка Тогда	//12
		Элементы.ДатаИВремяМонтажа.Видимость 	= Ложь;
		Элементы.ДатаИВремяДоставки.Видимость	= Ложь;
		Элементы.ДатаИВремяСборки.Видимость 	= Истина;
		Элементы.МатериалОсновы.Видимость 		= Ложь;
	Иначе 
		Элементы.ДатаИВремяМонтажа.Видимость 	= Ложь; 
		Элементы.ДатаИВремяСборки.Видимость 	= Ложь;
		Элементы.ДатаИВремяДоставки.Видимость	= Истина;
		Элементы.МатериалОсновы.Видимость 		= Истина;
	КонецЕсли;	
	
	Если Объект.ВидРабот = Перечисления.ВидыРабот.Накатка //6,13,14,9
		Или Объект.ВидРабот = Перечисления.ВидыРабот.СобственнаяПечатьНестандартныйРазмер
		или Объект.ВидРабот = Перечисления.ВидыРабот.СобственнаяПечатьЦветопроба 
		Или  Объект.ВидРабот = Перечисления.ВидыРабот.ПостпечатныеРаботы Тогда 
		Элементы.ПечатнаяМашина.Видимость 				= Истина;
		Элементы.РазрешениеПечати.Видимость 			= Истина;
		Элементы.ПоляПриПечати.Видимость 				= Истина;
		Элементы.РасположениеПолей.Видимость			= Истина;		
	иначе	
		Элементы.ПечатнаяМашина.Видимость 				= Ложь;
		Элементы.РазрешениеПечати.Видимость 			= Ложь;
		Элементы.ПоляПриПечати.Видимость 				= Ложь;
		Элементы.РасположениеПолей.Видимость			= Ложь;	
	КонецЕсли;
	
	Если Объект.ВидРабот = Перечисления.ВидыРабот.Дизайн Тогда //1 
		Элементы.СтраницаПостпечатныеРаботы.Видимость= Ложь;
		Элементы.ТехническиеХарактеристики.Видимость = Истина;
	Иначе 
		Элементы.ТехническиеХарактеристики.Видимость = Ложь;	
	КонецЕсли;	

	Если Объект.ВидРабот = Перечисления.ВидыРабот.ФрезернаяРезка //3,15
		Или Объект.ВидРабот = Перечисления.ВидыРабот.ЛазернаяРезка 
		Или Объект.ВидРабот = Перечисления.ВидыРабот.Гравировка Тогда 
		Элементы.КоличествоСторон.Видимость 			= Ложь;
		Элементы.ОбщееКоличествоПогонныхМетров.Видимость= Истина;
		Элементы.СтраницаПостпечатныеРаботы.Видимость 	= Ложь;
	КонецЕсли;
	
	Если Объект.ВидРабот = Перечисления.ВидыРабот.ИзготовлениеТаблички Тогда 
	    Элементы.ПечатнаяМашина.Видимость 				= Истина;
		Элементы.ОбщееКоличествоПогонныхМетров.Видимость= Истина;
		Элементы.МатериалОсновы.Видимость				= Истина;
	КонецЕсли;

КонецПроцедуры	

&НаКлиенте
Процедура ВидРаботПриИзменении(Элемент)
	 УстановкаВидимости();
КонецПроцедуры



