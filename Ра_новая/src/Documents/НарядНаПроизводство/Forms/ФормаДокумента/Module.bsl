// @strict-types


&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Не ЗначениеЗаполнено(Объект.Статус) Тогда 
		Объект.Статус 		= Перечисления.Статусы.Вработе;
		Модифицированность 	= Истина;
	КонецЕсли;
	
	Если Объект.Статус = Перечисления.Статусы.Закрыт И Не РольДоступна("НачальникЦеха") Тогда   
		Если Объект.Статус = Перечисления.Статусы.Закрыт И Не РольДоступна("УУ") Тогда	
			ЭтаФорма.ТолькоПросмотр = Истина;
		иначе
			ЭтаФорма.ТолькоПросмотр = Ложь;
		КонецЕсли;	
	Иначе
		ЭтаФорма.ТолькоПросмотр = Ложь;	
	КонецЕсли;
	
	Если (Объект.Статус = Перечисления.Статусы.ПеределкаЗаказа И РольДоступна("Менеджер")) 
		ИЛИ (Объект.Статус = Перечисления.Статусы.ПеределкаЗаказа И РольДоступна("Печатник")) Тогда
		ЭтаФорма.ТолькоПросмотр = Истина; //200622		                                     
	КонецЕсли;
	
	//Ав. установим тариф цеха
	Если Не ЗначениеЗаполнено(Объект.ТарифЦеха) Тогда 
		Если Объект.ТехническоеЗадание.ВидРабот = Перечисления.ВидыРабот.СобственнаяПечатьНестандартныйРазмер Тогда 
			Если Объект.ТехническоеЗадание.ПечатнаяМашина.ВидМашины = Перечисления.ВидыПечатныхМашин.Интерьерная Тогда  
				Объект.ТарифЦеха = 16; //Сделать авт
			ИначеЕсли Объект.ТехническоеЗадание.ПечатнаяМашина.ВидМашины = Перечисления.ВидыПечатныхМашин.Широкоформатная Тогда
				Объект.ТарифЦеха = 13;	//Сделать авт 
			КонецЕсли;
		ИначеЕсли Объект.ТехническоеЗадание.ВидРабот = Перечисления.ВидыРабот.Накатка Тогда 
			Объект.ТарифЦеха = 50;
		ИначеЕсли Объект.ТехническоеЗадание.ВидРабот = Перечисления.ВидыРабот.Резка Тогда 
			Объект.ТарифЦеха = 30;	
		ИначеЕсли Объект.ТехническоеЗадание.ВидРабот = Перечисления.ВидыРабот.Ламинация Тогда 
			Объект.ТарифЦеха = 10;		
		КонецЕсли;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Объект.Склад) Тогда 
		Объект.Склад = Справочники.Склады.НайтиПоНаименованию("Основной");
		Модифицированность = Истина;
	КонецЕсли;
	
	Элементы.тВидРабот.Заголовок = Объект.ТехническоеЗадание.ВидРабот;
	
	Если Объект.ТехническоеЗадание.ВидРабот = Перечисления.ВидыРабот.ЛазернаяРезка //180421
		или Объект.ТехническоеЗадание.ВидРабот = Перечисления.ВидыРабот.ФрезернаяРезка Тогда 
		Элементы.РежимПечатиРезка.Видимость = Истина;
		Элементы.РежимПечати.Видимость 		= Ложь;
	Иначе 
		Элементы.РежимПечатиРезка.Видимость = Ложь;
		Элементы.РежимПечати.Видимость 		= Истина;
	КонецЕсли;
	
	//1
	МассивИменКолонокДляПодсветки = Новый Массив;
	Для каждого Стр из Элементы.РасходМатериала.ПодчиненныеЭлементы Цикл
	    МассивИменКолонокДляПодсветки.Добавить(Стр.Имя);
	КонецЦикла;
	
	ЭлементОформленияГолубой = УсловноеОформление.Элементы.Добавить();
	ЭлементОформленияГолубой.Использование = Истина;
	ЭлементОформленияГолубой.Оформление.УстановитьЗначениеПараметра("ЦветФона",  WebЦвета.Розовый);
	
	ЭлементУсловияГолубой = ЭлементОформленияГолубой.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементУсловияГолубой.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("Объект.РасходМатериала.Остаток");
	ЭлементУсловияГолубой.ПравоеЗначение = 0; 
	ЭлементУсловияГолубой.ВидСравнения   = ВидСравненияКомпоновкиДанных.Меньше;   
	ЭлементУсловияГолубой.Использование  = Истина;
	
	Для каждого ТекЭлемент из МассивИменКолонокДляПодсветки Цикл
	    ОформляемоеПоле      = ЭлементОформленияГолубой.Поля.Элементы.Добавить();
		ОформляемоеПоле.Поле = Новый ПолеКомпоновкиДанных(ТекЭлемент);
	КонецЦикла;
	
	Если объект.Проведен Тогда 
		Элементы.Номер.ТолькоПросмотр 	= Ложь; //13.10.20
	КонецЕсли;	

	Элементы.Связан.Доступность = РольДоступна("ПолныеПрава");  	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьФИО(Команда)
	ПолучитьСоставБригады();
	ЭтаФорма.Модифицированность = Истина;
КонецПроцедуры

&НаСервере
Процедура ПолучитьСоставБригады()
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	СооставБригады.Печатник,
		|	СооставБригады.Техник1,
		|	СооставБригады.Техник2,
		|	СооставБригады.Техник3,
		|	СооставБригады.Период КАК Период
		|ИЗ
		|	РегистрСведений.СооставБригады КАК СооставБригады
		|ГДЕ
		|	СооставБригады.Период <= &НаДату
		|
		|УПОРЯДОЧИТЬ ПО
		|	Период УБЫВ";

	Если ЗначениеЗаполнено(Объект.ДатаВыполненияНаряда) Тогда 
		Запрос.УстановитьПараметр("НаДату", КонецДня(Объект.ДатаВыполненияНаряда));
	иначе
		Запрос.УстановитьПараметр("НаДату", КонецДня(Объект.Дата));
	КонецЕсли;

	Результат = Запрос.Выполнить();
	табРезультат = Результат.выгрузить();
	ВыборкаДетальныеЗаписи = Результат.Выбрать();
	
	ВыборкаДетальныеЗаписи.Следующий();
	Объект.СоставБригады.Очистить();
	Если ЗначениеЗаполнено(ВыборкаДетальныеЗаписи.Печатник) тогда
		новСтрока = объект.СоставБригады.добавить();
		новСтрока.ФИО 			=  ВыборкаДетальныеЗаписи.Печатник;
		новСтрока.Статус 		=  Перечисления.СтатусыРаботников.Печатник;
	КонецЕсли;
	Если ЗначениеЗаполнено(ВыборкаДетальныеЗаписи.Техник1) тогда
		новСтрока = объект.СоставБригады.добавить();
		новСтрока.ФИО 			=  ВыборкаДетальныеЗаписи.Техник1;
		новСтрока.Статус 		=  Перечисления.СтатусыРаботников.Техник;
	КонецЕсли;
	Если ЗначениеЗаполнено(ВыборкаДетальныеЗаписи.Техник2) тогда
		новСтрока = объект.СоставБригады.добавить();
		новСтрока.ФИО 			=  ВыборкаДетальныеЗаписи.Техник2;
		новСтрока.Статус 		=  Перечисления.СтатусыРаботников.Техник;
	КонецЕсли;
	Если ЗначениеЗаполнено(ВыборкаДетальныеЗаписи.Техник3) тогда
		новСтрока = объект.СоставБригады.добавить();
		новСтрока.Статус 		=  Перечисления.СтатусыРаботников.Техник;
	КонецЕсли;
	РассчитатьФЗП();
КонецПроцедуры	     

&НаСервере
Процедура РассчитатьФЗП()
	
	счПечатник = 0;
	счТехник   = 0;
	
	Для Каждого стрТЧ из Объект.СоставБригады цикл
		Если стрТЧ.Статус = Перечисления.СтатусыРаботников.Печатник Тогда 
			счПечатник = счПечатник+1;
		ИначеЕсли стрТЧ.Статус = Перечисления.СтатусыРаботников.Техник Тогда 
			счТехник = счТехник+1;
		КонецЕсли;	
	КонецЦикла;	
	
	ЗапросТариф = Новый Запрос;
	ЗапросТариф.Текст = 
	"ВЫБРАТЬ
	|	ТарифЦехаСрезПоследних.ПроцентТехника,
	|	ТарифЦехаСрезПоследних.ПроцентПечатника,
	|	ТарифЦехаСрезПоследних.Тариф
	|ИЗ
	|	РегистрСведений.ТарифЦеха.СрезПоследних(
	|			&НаДату,
	|			КолПечатников = &КолПечатников
	|				И КолТехников = &КолТехников) КАК ТарифЦехаСрезПоследних";
	
	ЗапросТариф.УстановитьПараметр("НаДату", Объект.Дата);
	ЗапросТариф.УстановитьПараметр("КолТехников",счТехник);
	ЗапросТариф.УстановитьПараметр("КолПечатников",счПечатник);
	
	РезультатТариф 	= ЗапросТариф.Выполнить();
	
	Если РезультатТариф.Пустой() Тогда 
		Сообщить("Для печатников: "+счПечатник+", техников: "+счТехник+" нет тарифа");
		Возврат;		
	КонецЕсли;	
	
	Выборка = РезультатТариф.Выбрать();
	Выборка.Следующий();
	
	Тариф = ?(ЗначениеЗаполнено(Объект.ТарифЦеха),Объект.ТарифЦеха,Выборка.Тариф); 
	
	Для Каждого стрТЧ из Объект.СоставБригады цикл
		Если стрТЧ.Статус = Перечисления.СтатусыРаботников.Печатник Тогда 
			стрТЧ.ПроцентОплаты = Выборка.ПроцентПечатника;
		ИначеЕсли стрТЧ.Статус = Перечисления.СтатусыРаботников.Техник Тогда 
			стрТЧ.ПроцентОплаты = Выборка.ПроцентТехника;
		КонецЕсли;
		стрТЧ.Тариф = Тариф;
		Если ЗначениеЗаполнено(Объект.ТехническоеЗадание.ОбщаяПлощадьИзображения) Тогда 
			стрТЧ.ФЗП_ПоТарифу  =  Объект.ТехническоеЗадание.ОбщаяПлощадьИзображения*(стрТЧ.Тариф)*(стрТЧ.ПроцентОплаты/100);
		Иначе 
			стрТЧ.ФЗП_ПоТарифу  = 0;
		КонецЕсли;
		стрТЧ.ДопФЗП = 0; //Заплатка
		стрТЧ.Итого  		=  стрТЧ.ФЗП_ПоТарифу+стрТЧ.ДопФЗП;
		
	КонецЦикла;	
	
КонецПроцедуры

&НаКлиенте
Процедура РасходМатериалаНомерРулонаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	Парам = Новый Структура;
	Парам.Вставить("ДатаДок",Объект.Дата);
	ОткрытьФорму("ОбщаяФорма.ФормаВыбораРулонов",Парам,ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	ТекущиеДанные = Элементы.РасходМатериала.ТекущиеДанные;
	ТекущиеДанные.НомерРулона 	= ВыбранноеЗначение.Рулон;
	ТекущиеДанные.МатериалОсновы= ВыбранноеЗначение.МатериалОсновы;
	ТекущиеДанные.ШиринаРулона 	= ВыбранноеЗначение.Ширина;
	ТекущиеДанные.Остаток 		= ПолучитьОстатокРулона(ВыбранноеЗначение.Рулон);
КонецПроцедуры

&НаСервере
Функция ПолучитьОстатокРулона(Рулон)
	  Возврат ОбщегоНазначения.ПолучитьОстатокРулона(Объект.Дата+1,Рулон);
КонецФункции	

&НаКлиенте
Процедура РассчитатьКоличествоИзрасходованногоМатериала()
	ТекущиеДанные = Элементы.РасходМатериала.ТекущиеДанные;
	ТекущиеДанные.КоличествоИзрасходованногоМатериала = ТекущиеДанные.ШиринаРулона*ТекущиеДанные.РасходМатериала;
КонецПроцедуры

&НаКлиенте
Процедура РасходМатериалаРасходМатериалаПриИзменении(Элемент)
	РассчитатьКоличествоИзрасходованногоМатериала();
КонецПроцедуры

&НаКлиенте
Процедура СвязанныеНарядыПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	Если Объект.СвязанныеНаряды.Количество()=0 Тогда 
		ДобавитьПервуюСтроку();
	КонецЕсли;	
КонецПроцедуры

&НаСервере
Процедура ДобавитьПервуюСтроку()
	 НоваяСтрока = Объект.СвязанныеНаряды.Добавить();
	 НоваяСтрока.Наряд = Объект.Ссылка;
КонецПроцедуры	

&НаКлиенте
Процедура РасчитатьКоличествоИзрасходованногоМатериала(Команда)
	Если ЭтаФорма.Модифицированность Тогда 
		Записать();
	КонецЕсли;	
	РасчитатьОбщКоличествоИзрасходованногоМатериала();
КонецПроцедуры
 
 &НаСервере
Процедура РасчитатьОбщКоличествоИзрасходованногоМатериала()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	НарядНаПроизводствоРасходМатериала.КоличествоИзрасходованногоМатериала КАК ОбщаяПлощадьПечатиФакт,
		|	НарядНаПроизводствоРасходМатериала.РасходМатериала КАК РасхМат
		|ИЗ
		|	Документ.НарядНаПроизводство.РасходМатериала КАК НарядНаПроизводствоРасходМатериала
		|ГДЕ
		|	НарядНаПроизводствоРасходМатериала.Ссылка В(&спНарядов)";

	Запрос.УстановитьПараметр("спНарядов", Объект.СвязанныеНаряды.Выгрузить(,"Наряд"));
	
	Результат = Запрос.Выполнить();
	ВыборкаДетальныеЗаписи 	= Результат.Выбрать();
	ОбщаяПлощадьПечатиФакт 	= 0;
	ОбщРасходМатериала 		= 0;  
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл 		
		ОбщаяПлощадьПечатиФакт 	= ОбщаяПлощадьПечатиФакт+ВыборкаДетальныеЗаписи.ОбщаяПлощадьПечатиФакт;
		Если ВыборкаДетальныеЗаписи.ОбщаяПлощадьПечатиФакт>0 Тогда //270720
			ОбщРасходМатериала 		= ОбщРасходМатериала+ВыборкаДетальныеЗаписи.РасхМат;
		КонецЕсли;
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СУММА(НарядНаПроизводство.ТехническоеЗадание.ОбщаяПлощадьИзображения) КАК ОбщаяПлощадьИзображения
		|ИЗ
		|	Документ.НарядНаПроизводство КАК НарядНаПроизводство
		|ГДЕ
		|	НарядНаПроизводство.Ссылка В(&Ссылка)";

	Запрос.УстановитьПараметр("Ссылка", Объект.СвязанныеНаряды.Выгрузить(,"Наряд"));

	Результат = Запрос.Выполнить();
	ВыборкаДетальныеЗаписи = Результат.Выбрать();
	ВыборкаДетальныеЗаписи.Следующий();
	
	ОбщаяПлощадьИзображения = ВыборкаДетальныеЗаписи.ОбщаяПлощадьИзображения;  
	
	Для каждого стрСвНаряд из Объект.СвязанныеНаряды цикл
		стрСвНаряд.КоличествоИзрасходованногоМатериала  = стрСвНаряд.Наряд.ТехническоеЗадание.ОбщаяПлощадьИзображения/ОбщаяПлощадьИзображения*ОбщаяПлощадьПечатиФакт;
		Если стрСвНаряд.КоличествоИзрасходованногоМатериала>0 Тогда 
			колИзрасхМатМетрПогон 			= (ОбщРасходМатериала*стрСвНаряд.КоличествоИзрасходованногоМатериала)/ОбщаяПлощадьПечатиФакт;
			стрСвНаряд.КолИзрасходМатериала_МП 	= колИзрасхМатМетрПогон;	
		КонецЕсли;	 
	КонецЦикла;	
	
КонецПроцедуры	 

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	Для Каждого стр из Объект.СвязанныеНаряды Цикл
		докОбъект = стр.наряд.получитьОбъект();
		докОбъект.СвязанныеНаряды.Очистить();
		докОбъект.СвязанныеНаряды.Загрузить(Объект.СвязанныеНаряды.Выгрузить());
		докОбъект.Связан = Истина;
		докОбъект.записать();
	КонецЦикла;
КонецПроцедуры


&НаКлиенте
Процедура ТехническоеЗаданиеОткрытие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	//Вариант 1
	//тФорма = ПолучитьФорму("Документ.Заявка.Форма.ФормаДокументаДляЦеха",новый Структура("Ключ",Объект.ТехническоеЗадание));
	//тФорма.ТолькоПросмотр = истина;
	//тФорма.Открыть();
	
	//Вариант 2
	//ОткрытьФорму("Документ.Заявка.Форма.ФормаДокументаДляЦеха",новый Структура("Ключ",Объект.ТехническоеЗадание)).ТолькоПросмотр=Истина;
	
	ОткрытьФорму("Документ.Заявка.Форма.ФормаДокументаДляЦеха",новый Структура("Ключ",Объект.ТехническоеЗадание));
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Для каждого стр из Объект.РасходМатериала цикл
		Если ЗначениеЗаполнено(стр.НомерРулона) Тогда 		
				//Проверим материал основы
				СтрукутраДляПроверки = Новый Структура;
				СтрукутраДляПроверки.Вставить("НомерРулона",стр.НомерРулона);
				СтрукутраДляПроверки.Вставить("МатериалОсновы",стр.МатериалОсновы);

				Совпадает = СовпадаетМатериалОсновы(СтрукутраДляПроверки);
				Если Не Совпадает Тогда 
					Сообщить("Не совпадает материал основы "+стр.НомерРулона);
				КонецЕсли;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры
	 
&НаСервере
Функция СовпадаетМатериалОсновы(СтрукутраДляПроверки)
	Возврат ОбщегоНазначения.ПроверитьМатериалОсновы(СтрукутраДляПроверки);
КонецФункции

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	Для Каждого стр из Объект.РасходМатериала Цикл 
		стр.Остаток = ПолучитьОстатокРулона(стр.НомерРулона);
		Если стр.Остаток<0 Тогда 
			Объект.СодержитОшибки = Истина;	
		иначе
			Объект.СодержитОшибки = Ложь; //241021	
		КонецЕсли;	
	КонецЦикла;
КонецПроцедуры




