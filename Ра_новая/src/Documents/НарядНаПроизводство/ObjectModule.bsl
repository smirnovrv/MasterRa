// @strict-types


Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Движения.Материалы.Записывать	 	= Истина; //инф о материале б\з номера рулона
	Движения.Рулоны.Записывать 			= Истина; //инф о рулоне
	Движения.Наряды.Записывать 			= Истина; //инф о самом наряде, для отчета
		
	СрЦенаРулона 		= 0;
	ЗатратыНаМатериал	= 0;
	ЗатратыПрочие       = 0;
	ОбщРасходМатериала	= 0;
	ЦенаРулонаПечати    = 0;
	
	ОбПлощадьИзрасхМат 	= ПолучитьОбщПлощадьИзрасхМат();
	ОбКолИзрасхМат 		= ПолучитьОбщКолИзрасхМат();
	
	Для каждого стр из РасходМатериала цикл	
		Если ЗначениеЗаполнено(стр.НомерРулона) Тогда
			структура 	= ОбщегоНазначения.ПолучитьПоРулону(дата-1,стр.НомерРулона);		
			СрЦенаРулона= ОбщегоНазначения.ПолучитьЦенуРулона(стр.НомерРулона,Дата);
			
			//Проверим материал основы
			СтрукутраДляПроверки = Новый Структура;
			СтрукутраДляПроверки.Вставить("НомерРулона",стр.НомерРулона);
			СтрукутраДляПроверки.Вставить("МатериалОсновы",стр.МатериалОсновы);
			
			Отказ = Не ОбщегоНазначения.ПроверитьМатериалОсновы(СтрукутраДляПроверки);
			Если Отказ Тогда 
				Сообщить(Номер+" Не совпадает материал основы");
			КонецЕсли;
			
			ЗаписьРасходРулона = Движения.Рулоны.Добавить();		
			ЗаписьРасходРулона.Рулон       		= стр.НомерРулона;
			ЗаписьРасходРулона.Материал         = структура.Материал;	
		иначе
			ЗаписьРасходРулона = Движения.Материалы.Добавить();
		КонецЕсли;	
		ЗаписьРасходРулона.Период 			= Ссылка.дата;
		ЗаписьРасходРулона.ВидДвижения 		= ВидДвиженияНакопления.Расход;
		ЗаписьРасходРулона.Количество  		= стр.РасходМатериала;
		ЗаписьРасходРулона.МатериалОсновы	= стр.МатериалОсновы; 
		ЗаписьРасходРулона.Регистратор 		= Ссылка;
		
		Если стр.КоличествоИзрасходованногоМатериала>0 Тогда 
			ЗатратыНаМатериал = ЗатратыНаМатериал+(стр.РасходМатериала*СрЦенаРулона);
			ЦенаРулонаПечати  = СрЦенаРулона; 
		иначе
			ЗатратыПрочие = ЗатратыПрочие+(стр.РасходМатериала*СрЦенаРулона);
		КонецЕсли;
	КонецЦикла;				
	
	ЗаписьНаряда = Движения.Наряды.Добавить();
	ЗаписьНаряда.Период 				= дата;
	ЗаписьНаряда.КодЗаказа     			= номер;
	ЗаписьНаряда.Регистратор 			= Ссылка;
	Если ЗначениеЗаполнено(Ссылка.ТехническоеЗадание) Тогда 
		ЗаписьНаряда.ОбПлощадьИзображения	= Ссылка.ТехническоеЗадание.ОбщаяПлощадьИзображения;
	иначе
		ЗаписьНаряда.ОбПлощадьИзображения	= 0;
	КонецЕсли;	
	
	Если Связан Тогда
		Для Каждого стрСв из СвязанныеНаряды цикл
			ТЧ_РасходМатериала = стрСв.Наряд.РасходМатериала;
			Если ТЧ_РасходМатериала.Количество()>0 Тогда 
				Для Каждого стр из ТЧ_РасходМатериала Цикл 
					Если стр.КоличествоИзрасходованногоМатериала>0 Тогда 
						СрЦенаРулона		= ОбщегоНазначения.ПолучитьЦенуРулона(стр.НомерРулона,Дата);
						ОбщРасходМатериала	= стр.РасходМатериала;
					КонецЕсли;
				КонецЦикла;
			КонецЕсли;
			
			Если стрСв.Наряд = Ссылка Тогда
				ЗаписьНаряда.СвНаряды			= ПолучитьСтрСв(Ссылка);
				ЗаписьНаряда.ОбПлощадьИзрасхМат	= стрСв.КоличествоИзрасходованногоМатериала;
				
				Если стрСв.КолИзрасходМатериала_МП=0 Тогда 
					Если стрСв.КоличествоИзрасходованногоМатериала>0 Тогда 
						колИзрасхМатМетрПогон 			= ОбщРасходМатериала*стрСв.КоличествоИзрасходованногоМатериала/ОбПлощадьИзрасхМат;
						стрСв.КолИзрасходМатериала_МП 	= колИзрасхМатМетрПогон;	
					КонецЕсли;										
				КонецЕсли;
				ЗаписьНаряда.ЗатратыНаМатериал = СрЦенаРулона*стрСв.КолИзрасходМатериала_МП;

			КонецЕсли;
		КонецЦикла;
	Иначе
		ЗаписьНаряда.ОбПлощадьИзрасхМат		= ОбПлощадьИзрасхМат;
		ЗаписьНаряда.СвНаряды				= "";
		ЗаписьНаряда.Цена 						= ?(ЦенаРулонаПечати=0,СрЦенаРулона,ЦенаРулонаПечати);
		ЗаписьНаряда.ЗатратыНаМатериал      	= ЗатратыНаМатериал;		
	КонецЕсли;
	
	ЗаписьНаряда.ЗатратыНаПрочиеСобМат  = ЗатратыПрочие;
	ЗаписьНаряда.Цена 					= ?(ЦенаРулонаПечати=0,СрЦенаРулона,ЦенаРулонаПечати);;

КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	Если Статус = Перечисления.Статусы.Проверен Тогда 
		Если Не РольДоступна("НачальникЦеха") Тогда 
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Поле	= "Статус";
			Сообщение.Текст = "Нет прав для установки";
			Сообщение.Сообщить();
			Отказ = Истина;
		КонецЕсли;		
	КонецЕсли;
	ФЗПцеха = СоставБригады.Итог("Итого");
КонецПроцедуры

Функция ПолучитьОбщПлощадьИзрасхМат()
	ОбПлощадьИзрасхМат = 0;
	
	Если Ссылка.Связан Тогда 
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЕСТЬNULL(НарядНаПроизводствоРасходМатериала.КоличествоИзрасходованногоМатериала, 0) КАК КоличествоИзрасходованногоМатериала
		|ИЗ
		|	Документ.НарядНаПроизводство.РасходМатериала КАК НарядНаПроизводствоРасходМатериала
		|ГДЕ
		|	НарядНаПроизводствоРасходМатериала.Ссылка В(&спНарядов)";
		
		Запрос.УстановитьПараметр("спНарядов", СвязанныеНаряды.Выгрузить(,"Наряд"));
		
		РезультатЗапроса = Запрос.Выполнить();
		
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			ОбПлощадьИзрасхМат 	= ОбПлощадьИзрасхМат+ВыборкаДетальныеЗаписи.КоличествоИзрасходованногоМатериала; 
		КонецЦикла;		
	Иначе 
		ОбПлощадьИзрасхМат 	= РасходМатериала.Итог("КоличествоИзрасходованногоМатериала");
	КонецЕсли;

	Если ОбПлощадьИзрасхМат = 0 Тогда
		Если ТехническоеЗадание.ВидРабот = Перечисления.ВидыРабот.СобственнаяПечатьНестандартныйРазмер
			И ЗначениеЗаполнено(ТехническоеЗадание.ОбщаяПлощадьИзображения) Тогда
			ОбПлощадьИзрасхМат = ТехническоеЗадание.ОбщаяПлощадьИзображения;
		КонецЕсли;
	КонецЕсли;

	Возврат ОбПлощадьИзрасхМат;
КонецФункции	
	
Функция ПолучитьОбщКолИзрасхМат()
	ОбКолИзрасхМат = 0;
	
	Если Ссылка.Связан Тогда 
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	НарядНаПроизводствоРасходМатериала.НомерРулона КАК НомерРулона,
		|	НарядНаПроизводствоРасходМатериала.РасходМатериала КАК РасходМатериала
		|ИЗ
		|	Документ.НарядНаПроизводство.РасходМатериала КАК НарядНаПроизводствоРасходМатериала
		|ГДЕ
		|	НарядНаПроизводствоРасходМатериала.Ссылка В(&спНарядов)
		|	И НарядНаПроизводствоРасходМатериала.КоличествоИзрасходованногоМатериала > 0";
		
		Запрос.УстановитьПараметр("спНарядов", СвязанныеНаряды.Выгрузить(,"Наряд"));
		
		РезультатЗапроса = Запрос.Выполнить();
		
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			ОбКолИзрасхМат 	= ОбКолИзрасхМат+ВыборкаДетальныеЗаписи.РасходМатериала; 
		КонецЦикла;	
	Иначе 
		ОбКолИзрасхМат 		= РасходМатериала.Итог("РасходМатериала");
	КонецЕсли;	
	
	Возврат ОбКолИзрасхМат;
КонецФункции	
	
Функция ПолучитьСтрСв(Ссылка)
	
	 СвНаряды="";
	
	 Запрос = Новый Запрос;
	 Запрос.Текст = 
	 "ВЫБРАТЬ
	 |	НарядНаПроизводствоСвязанныеНаряды.Наряд.Номер
	 |ИЗ
	 |	Документ.НарядНаПроизводство.СвязанныеНаряды КАК НарядНаПроизводствоСвязанныеНаряды
	 |ГДЕ
	 |	НарядНаПроизводствоСвязанныеНаряды.Ссылка = &Ссылка
	 |	И НарядНаПроизводствоСвязанныеНаряды.Наряд.Ссылка <> &Ссылка";
	 
	 Запрос.УстановитьПараметр("Ссылка", ссылка);
	 
	 Результат = Запрос.Выполнить();
	 
	 ВыборкаДетальныеЗаписи = Результат.Выбрать();
	 
	 СвНаряды = "";
	 Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		 Если СвНаряды="" Тогда 
			 СвНаряды = СвНаряды+ВыборкаДетальныеЗаписи.НарядНомер;
		 Иначе
			 СвНаряды = СвНаряды+", "+ВыборкаДетальныеЗаписи.НарядНомер;
		 КонецЕсли;
	 КонецЦикла;
	 
	
	Возврат СвНаряды;
КонецФункции
	
	