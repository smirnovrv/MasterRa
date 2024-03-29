// @strict-types


Процедура ПечатьМ2(ТабДок, ПараметрКоманды) Экспорт 
	
	Макет = ПолучитьМакет("ПФ_MXL_М2");
	
	ФамилияИмяОтчествоДоверенного = СокрЛП(ПараметрКоманды.ФизЛицо.Фамилия) 
	+ " " + Лев(СокрЛП(ПараметрКоманды.ФизЛицо.Имя),1)+"." 
	+ " " + Лев(ПараметрКоманды.ФизЛицо.Отчество,1)+".";
	
	Должность = ПараметрКоманды.ФизЛицо.Должность.Наименование;
	
	ОбластьМакета = Макет.ПолучитьОбласть("Отрез");
	ОбластьМакета.Параметры.НомерДокумента 					= ПараметрКоманды.Номер;
	ОбластьМакета.Параметры.ДатаДокумента 					= ПараметрКоманды.Дата;
	ОбластьМакета.Параметры.СрокДействия 					= ПараметрКоманды.ДатаДействия;
	ОбластьМакета.Параметры.ФИОДоверенного 		= "" + ?(ЗначениеЗаполнено(ПараметрКоманды.ФизЛицо.Должность),Должность + ", " + Символы.ПС,"") + (ФамилияИмяОтчествоДоверенного);
	Если ЗначениеЗаполнено(ПараметрКоманды.Контрагент) Тогда
		ОбластьМакета.Параметры.ПоставщикПредставление 	= ПараметрКоманды.Контрагент;
	иначе
		ОбластьМакета.Параметры.ПоставщикПредставление 	= ПараметрКоманды.НаПолучениеОт;
	КонецЕсли;
	ОбластьМакета.Параметры.РеквизитыДокументаНаПолучение	= ПараметрКоманды.ПоДокументу;
	ТабДок.Вывести(ОбластьМакета);
	
	ОбластьМакета = Макет.ПолучитьОбласть("Шапка");
	ОбластьМакета.Параметры.ОКУД 					= "0315001";
	ОбластьМакета.Параметры.ОрганизацияКодПоОКПО    = ПараметрКоманды.Организация.ОКПО;
	ОрганизацияПредставление = ПараметрКоманды.Организация.Наименование+", "+ПараметрКоманды.Организация.ИНН+", "
	+ПараметрКоманды.Организация.КПП+", "+ПараметрКоманды.Организация.ЮридическийАдрес+", "+ПараметрКоманды.Организация.Телефон;
	ОбластьМакета.Параметры.ОрганизацияПредставление= ОрганизацияПредставление;
	ОбластьМакета.Параметры.НомерДокумента 					= ПараметрКоманды.Номер;
	ОбластьМакета.Параметры.ДатаДокумента	 				= ПараметрКоманды.Дата;
	ОбластьМакета.Параметры.СрокДействия		 			= ПараметрКоманды.ДатаДействия;
	ОбластьМакета.Параметры.РеквизитыПотребителя			= ОрганизацияПредставление;
	ОбластьМакета.Параметры.РеквизитыПлательщика			= ОрганизацияПредставление;
	РеквизитыСчета = ПараметрКоманды.Организация.БанковскийСчет.НомерСчета+", "
							+ПараметрКоманды.Организация.БанковскийСчет.Банк+", "
							+ПараметрКоманды.Организация.БанковскийСчет.БИК+", "
							+ПараметрКоманды.Организация.БанковскийСчет.КорреспондентскийСчет;
	ОбластьМакета.Параметры.РеквизитыСчета	 				= РеквизитыСчета;
	ОбластьМакета.Параметры.ДолжностьДоверенного			= Должность;
	ФамилияИмяОтчествоДоверенного = ПараметрКоманды.ФизЛицо.Фамилия+" "+ПараметрКоманды.ФизЛицо.Имя+" "+ПараметрКоманды.ФизЛицо.Отчество;
	ОбластьМакета.Параметры.ФамилияИмяОтчествоДоверенного	= ФамилияИмяОтчествоДоверенного;
	ОбластьМакета.Параметры.ПаспортСерия			= ПараметрКоманды.ФизЛицо.СерияПаспорта;
	ОбластьМакета.Параметры.ПаспортНомер			= ПараметрКоманды.ФизЛицо.НомерПаспорта;
	ОбластьМакета.Параметры.ПаспортВыдан			= ПараметрКоманды.ФизЛицо.ПаспортВыдан;
	ОбластьМакета.Параметры.ПаспортДатаВыдачи		= ПараметрКоманды.ФизЛицо.ДатаВыдачиПаспорта;
	Если ЗначениеЗаполнено(ПараметрКоманды.Контрагент) Тогда
		ОбластьМакета.Параметры.ПоставщикПредставление 	= ПараметрКоманды.Контрагент;
	иначе
		ОбластьМакета.Параметры.ПоставщикПредставление 	= ПараметрКоманды.НаПолучениеОт;
	КонецЕсли;
	ОбластьМакета.Параметры.РеквизитыДокументаНаПолучение	= ПараметрКоманды.ПоДокументу;	
	ТабДок.Вывести(ОбластьМакета);
	
	ОбластьМакетаЗаголовокТаблицы = Макет.ПолучитьОбласть("ЗаголовокТаблицы");
	ТабДок.Вывести(ОбластьМакетаЗаголовокТаблицы);
	
	ОбластьМакетаСтрока = Макет.ПолучитьОбласть("Строка");
	Для Каждого стрТовары из ПараметрКоманды.Товары Цикл 
		ОбластьМакетаСтрока.Параметры.Номер 							= стрТовары.НомерСтроки;
		ОбластьМакетаСтрока.Параметры.ЦенностиПредставление 			= стрТовары.НаименованиеТовара;
		ОбластьМакетаСтрока.Параметры.ЕдиницаИзмеренияПредставление 	= стрТовары.ЕдиницаПоКлассификатору;
		ОбластьМакетаСтрока.Параметры.КоличествоПрописью			 	= ОбщегоНазначения.КоличествоПрописью(стрТовары.Количество); 
		ТабДок.Вывести(ОбластьМакетаСтрока);
	КонецЦикла;

	Руководитель 		= ПолучениеСписков.ОтвественныхЛиц(ПараметрКоманды.Организация,Перечисления.ОтветственныеЛица.Руководитель,ПараметрКоманды.Дата);
	ГлавныйБухгалтер 	= ПолучениеСписков.ОтвественныхЛиц(ПараметрКоманды.Организация,Перечисления.ОтветственныеЛица.ГлавныйБухгалтер,ПараметрКоманды.Дата);
	
	ОбластьМакетаПодвал = Макет.ПолучитьОбласть("Подвал");
	Если ЗначениеЗаполнено(Руководитель) Тогда 
		ОбластьМакетаПодвал.Параметры.ФИОРуководителя = Руководитель.ФизическоеЛицо;
	иначе
		ОбластьМакетаПодвал.Параметры.ФИОРуководителя = "";
	КонецЕсли;	
	
	Если ЗначениеЗаполнено(ГлавныйБухгалтер) Тогда 
		ОбластьМакетаПодвал.Параметры.ФИОГлавногоБухгалтера	= ГлавныйБухгалтер.ФизическоеЛицо;
	Иначе
		ОбластьМакетаПодвал.Параметры.ФИОГлавногоБухгалтера	= "";
	КонецЕсли;

	ТабДок.Вывести(ОбластьМакетаПодвал);

КонецПроцедуры	
