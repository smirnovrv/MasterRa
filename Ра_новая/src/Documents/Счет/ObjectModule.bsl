// @strict-types

Перем ПолноеИмяФайла;
Перем ИмяФайла;

Процедура ПриУстановкеНовогоНомера(СтандартнаяОбработка, Префикс)
	Префикс = Организация.Префикс;
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	Если Не ДанныеЗаполнения = Неопределено Тогда 			
			Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.Заявка") И ДанныеЗаполнения.Проведен Тогда				
				Если Не ДанныеЗаполнения.Проведен Тогда            
					СтандартнаяОбработка = Ложь;
					Возврат;
				КонецЕсли; 	
				
				Договор 		= ДанныеЗаполнения.Договор;
				Отвественный	= ДанныеЗаполнения.Менеджер;
				Организация 	= ДанныеЗаполнения.Организация;
				Контрагент 		= ДанныеЗаполнения.Контрагент;
				БанковскийСчет 	= ДанныеЗаполнения.Организация.БанковскийСчет;
				НДС_В_томЧисле  = ДанныеЗаполнения.Организация.НДС_В_томЧисле;
				
				ИтогоЗаВесьЗаказ = 0;			
				ИтогоЗаВесьЗаказ = ?(ИтогоЗаВесьЗаказ=0,ДанныеЗаполнения.ИтогоЗаВесьЗаказ,ИтогоЗаВесьЗаказ);
				
				новСтрока = Товары.Добавить();			
				новСтрока.Количество 	= ДанныеЗаполнения.Тираж;
				новСтрока.КодЗаказа 	= ДанныеЗаполнения.ссылка;
				новСтрока.НДС       	= Организация.СтавкаНДС;
				новСтрока.Номенклатура 	= ДанныеЗаполнения.ИнформацияВСчете;
				новСтрока.СуммаНДС      = ?(новСтрока.НДС = Перечисления.СтавкиНДС.НДС20,ИтогоЗаВесьЗаказ*20/120,0);
				новСтрока.Сумма         = ИтогоЗаВесьЗаказ-новСтрока.СуммаНДС;
				новСтрока.Цена          = новСтрока.Сумма/?(новСтрока.Количество=0,1,новСтрока.Количество);
				новСтрока.Всего         = ИтогоЗаВесьЗаказ;             			
			КонецЕсли;		
		КонецЕсли;	

КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	СуммаДокумента = Товары.Итог("Всего");
	Если  РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда 
		
		//Выгрузим на ФТП		
		тНомер = Номер;
		поискФ = СтрНайти(тНомер,"/");
		Если поискФ>0 Тогда 
			тНомер = СтрЗаменить(Номер,"/","_");
		КонецЕсли;
		
		//Если Организация.ИНН = "667472326758" Тогда
		//	ИмяФайла = "IP\IP_invoice_"+Формат(Дата,"ДФ='ддММгггг'")+"_"+СокрЛП(тНомер)+".xml"; 			
		//ИначеЕсли Организация.ИНН = "6671320017" Тогда 	
		//	ИмяФайла = "RA\RA_invoice_"+Формат(Дата,"ДФ='ддММгггг'")+"_"+СокрЛП(тНомер)+".xml";
		//ИначеЕсли  Организация.ИНН = "6679121870" Тогда 
		//	ИмяФайла = "TX\TX_invoice_"+Формат(Дата,"ДФ='ддММгггг'")+"_"+СокрЛП(тНомер)+".xml";
		//Иначе 
		//	ИмяФайла = "invoice_"+Формат(Дата,"ДФ='ддММгггг'")+"_"+СокрЛП(тНомер)+".xml"; //01.06.22	
		//КонецЕсли;
		//ПолноеИмяФайла = "C:\Obmen\"+ИмяФайла;	
		//
		//ЗаписьXML = Новый ЗаписьXML;
		//ЗаписьXML.ОткрытьФайл(ПолноеИмяФайла);
		//
		//ЗаписьXML.ЗаписатьОбъявлениеXML();
		//ЗаписьXML.ЗаписатьНачалоЭлемента("Счета");	
				
		для Каждого стрТЧ из Товары цикл
			Если стрТЧ.Номенклатура.ПометкаУдаления Тогда 
				Сообщить("Продукция "+стрТЧ.Номенклатура+" помечена на удаление");
				Отказ = истина; //13.08.20
			КонецЕсли;	
			Если ЗначениеЗаполнено(стрТЧ.КодЗаказа) Тогда 
				Если ЗначениеЗаполнено(стрТЧ.КодЗаказа.Счет) Тогда
					Если стрТЧ.КодЗаказа.Счет<>Ссылка Тогда 
						Сообщить("В заказе: "+стрТЧ.КодЗаказа+" уже есть счет: "+стрТЧ.КодЗаказа.Счет);
						Если Не ПараметрыСеанса.ТекущийПользователь = Справочники.Пользователи.НайтиПоНаименованию("Смирнов Роман Викторович") Тогда 						
							Отказ = истина;
							Прервать;
						КонецЕсли;
					КонецЕсли;
				иначе
					Заказ = стрТЧ.КодЗаказа.ПолучитьОбъект();
					Заказ.Счет = Ссылка;
					Попытка 
						Заказ.Записать(РежимЗаписиДокумента.Проведение);  //доб. 14.01.20
					Исключение
						Заказ.Записать();
					КонецПопытки;
				КонецЕсли;
				
				Если Не ЗначениеЗаполнено(стрТЧ.КодЗаказа) Тогда 
					Сообщить("В строке: "+стрТЧ.НомерСтроки+" нет кода заказа");
					Отказ = истина;
					Прервать;
				КонецЕсли;
			КонецЕсли;
			
			//ЗаписьXML.ЗаписатьНачалоЭлемента("Счет");	
			//ЗаписьXML.ЗаписатьАтрибут("Дата",XMLСтрока(Дата));	
			//ЗаписьXML.ЗаписатьАтрибут("Номер",XMLСтрока(Номер));
			//
			//ЗаписьXML.ЗаписатьАтрибут("Контрагент",Контрагент.Наименование);
			//ЗаписьXML.ЗаписатьАтрибут("КонтрагентИНН",Контрагент.ИНН);
			//ЗаписьXML.ЗаписатьАтрибут("КонтрагентКПП",Контрагент.КПП);
			//ЗаписьXML.ЗаписатьАтрибут("КонтрагентПолное",Контрагент.НаименованиеПолное);
			//ЗаписьXML.ЗаписатьАтрибут("КонтрагентАдрес",Контрагент.ЮридическийАдрес);
			//
			//Если ЗначениеЗаполнено(Контрагент.НомерРасчетногоСчета) Тогда 
			//	ЗаписьXML.ЗаписатьАтрибут("НомерРС",Контрагент.НомерРасчетногоСчета);
			//	ЗаписьXML.ЗаписатьАтрибут("БИК",Контрагент.БИК);
			//	ЗаписьXML.ЗаписатьАтрибут("НаименованиеРС","Расчетный в "+Контрагент.Банк);
			//иначе
			//	ЗаписьXML.ЗаписатьАтрибут("НомерРС","");
			//	ЗаписьXML.ЗаписатьАтрибут("БИК","");
			//	ЗаписьXML.ЗаписатьАтрибут("НаименованиеРС","");
			//КонецЕсли;	
			//
			//ЗаписьXML.ЗаписатьАтрибут("Договор",Договор.Наименование);		
			//ЗаписьXML.ЗаписатьАтрибут("ОрганизацияИНН",Организация.ИНН);
			//ЗаписьXML.ЗаписатьАтрибут("ОрганизацияПрефикс",Организация.Префикс);
			//ЗаписьXML.ЗаписатьАтрибут("Ответственный",Отвественный.Наименование);
			//
			//ЗаписьXML.ЗаписатьАтрибут("ТоварНомерСтроки",Строка(стрТЧ.НомерСтроки));
			//ЗаписьXML.ЗаписатьАтрибут("Номенклатура",XMLСтрока(стрТЧ.Номенклатура));
			//ЗаписьXML.ЗаписатьАтрибут("ТоварНоменклатура",стрТЧ.Номенклатура.Наименование);
			//ЗаписьXML.ЗаписатьАтрибут("ТоварКоличество",Строка(стрТЧ.Количество));
			//ЗаписьXML.ЗаписатьАтрибут("ТоварЦена",Строка(стрТЧ.Цена));
			//ЗаписьXML.ЗаписатьАтрибут("ТоварСумма",Строка(стрТЧ.Сумма));
			//ЗаписьXML.ЗаписатьАтрибут("ТоварСуммаНДС",Строка(стрТЧ.СуммаНДС));
			//ЗаписьXML.ЗаписатьАтрибут("ТоварНДС",Строка(стрТЧ.НДС));
			//ЗаписьXML.ЗаписатьАтрибут("ТоварВсего",Строка(стрТЧ.Всего));
			//
			//Попытка
			//	ЗаписьXML.ЗаписатьАтрибут("ТоварКодЗаказа",стрТЧ.КодЗаказа.Номер);
			//Исключение
			//	ЗаписьXML.ЗаписатьАтрибут("ТоварКодЗаказа","");
			//КонецПопытки;
			//
			//ЗаписьXML.ЗаписатьКонецЭлемента();
			
		КонецЦикла;
		
		//ЗаписьXML.ЗаписатьКонецЭлемента();
		//ЗаписьXML.Закрыть();
		
	КонецЕсли;
	

КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	Если ЗначениеЗаполнено(ПолноеИмяФайла)И ЗначениеЗаполнено(ИмяФайла) Тогда;
		//ОбщегоНазначения.ПередатьНаFtp(ПолноеИмяФайла,ИмяФайла); 170720
	КонецЕсли;
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	Акт = Неопределено;
КонецПроцедуры

