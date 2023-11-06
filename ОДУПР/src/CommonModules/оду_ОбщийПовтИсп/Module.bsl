//ОМ.оду_ОбщийПовтИсп

#Область  ПрограммныйИнтерфейс

//TODO:  Подумать над реализацией
// Возвращает основные настройки узла обмена
// Параметры:
//  НастройкиРегистрации - строка - текст регистрации объектов узла - участника обмена
//  РежимОтладки	- Булево - Признак отладки
//  ПутьКОбработкиОтладки	- Строка - Путь к файловой обработке отладки
//  ИспользоватьОбработкуБСП	- Булево - Обработка берется с ДопОтчетовОбработок
//  ОбработкаОтладкиБСП	- СсылкаОбработки - Ссылка на внешнюю обработку
//  Логировать	- Булево - Признак записи ошибок в телеграмм
//  ЧатТелеграмм - Строка - ИД чата телеграмм
//
// Возвращаемое значение:
//  НастройкиРегистрации   - Структура с полями
//	Неопределено - В случае ошибки
//
Функция НастройкиРегистрации(БазаДанных = Неопределено)  Экспорт 
	
	Запрос = Новый Запрос;
	ЗапросТекст = 
		"ВЫБРАТЬ
		|	оду_НастройкиУчастниковОбмена.Ссылка.ЭтоРабочаяБД КАК ЭтоРабочаяБД,
		|	ЕСТЬNULL(оду_НастройкиУчастниковОбмена.НастройкаКонвертацииОбмена.КонфигурацияКонвертацииОбмена, оду_НастройкиУчастниковОбмена.Ссылка.НастройкаКонвертацииОбмена.КонфигурацияКонвертацииОбмена) КАК КонфигурацияКонвертацииОбмена,
		|	ЕСТЬNULL(оду_НастройкиУчастниковОбмена.НастройкаКонвертацииОбмена.НастройкиРегистрации, оду_НастройкиУчастниковОбмена.Ссылка.НастройкаКонвертацииОбмена.НастройкиРегистрации) КАК НастройкиРегистрации,
		|	ЕСТЬNULL(оду_НастройкиУчастниковОбмена.НастройкаКонвертацииОбмена.РежимОтладки, оду_НастройкиУчастниковОбмена.Ссылка.НастройкаКонвертацииОбмена.РежимОтладки) КАК РежимОтладки,
		|	ЕСТЬNULL(оду_НастройкиУчастниковОбмена.НастройкаКонвертацииОбмена.ПутьКОбработкиОтладки, оду_НастройкиУчастниковОбмена.Ссылка.НастройкаКонвертацииОбмена.ПутьКОбработкиОтладки) КАК ПутьКОбработкиОтладки,
		|	ЕСТЬNULL(оду_НастройкиУчастниковОбмена.НастройкаКонвертацииОбмена.ИспользоватьОбработкуБСП, оду_НастройкиУчастниковОбмена.Ссылка.НастройкаКонвертацииОбмена.ИспользоватьОбработкуБСП) КАК ИспользоватьОбработкуБСП,
		|	ЕСТЬNULL(оду_НастройкиУчастниковОбмена.НастройкаКонвертацииОбмена.ОбработкаОтладкиБСП, оду_НастройкиУчастниковОбмена.Ссылка.НастройкаКонвертацииОбмена.ОбработкаОтладкиБСП) КАК ОбработкаОтладкиБСП
		|ИЗ
		|	Справочник.оду_БазыУчастникиОбмена.Состав КАК оду_НастройкиУчастниковОбмена
		//|";
		|ГДЕ
		|	оду_НастройкиУчастниковОбмена.Ссылка.Используется = ИСТИНА
		|	#ГдеОтбор
		|";
	
	ГдеОтбор = "";
	Если БазаДанных = Неопределено Тогда
		ГдеОтбор = "И оду_НастройкиУчастниковОбмена.Ссылка.ТекущаяБД = ИСТИНА";
	Иначе
		ГдеОтбор = "И оду_НастройкиУчастниковОбмена.Ссылка = &БазаДанных";
		Запрос.УстановитьПараметр("БазаДанных", БазаДанных);
	КонецЕсли; 
	
	Запрос.Текст = СтрЗаменить(ЗапросТекст, "#ГдеОтбор", ГдеОтбор);
	
	РЗ = Запрос.Выполнить();

	Если РЗ.Пустой() Тогда
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Заполните 2 Регистра сведений: *Настройки узлов обмена БД
							|	И *Настройки БД ";
		Сообщение.Сообщить(); 
		Возврат Неопределено;
	КонецЕсли; 
	
	НастройкиРегистрации = пр_Общий.СтруктураПоЗапросу(РЗ);
	
	Возврат НастройкиРегистрации;	

КонецФункции // ()

// СсылкаУО - Ссылка на Участника обмена, если не задана, то Текущая
Функция НастройкиУчастникаОбмена(СсылкаУО = Неопределено)  Экспорт 

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	оду_БазыУчастникиОбмена.Ссылка КАК БазаДанных,
		|	оду_БазыУчастникиОбмена.Используется КАК Используется,
		|	оду_БазыУчастникиОбмена.ИспользоватьРегламентВыгрузкиДанных КАК ИспользоватьРегламентВыгрузкиДанных,
		|	оду_БазыУчастникиОбмена.ИспользоватьРегламентЗагрузкиДанных КАК ИспользоватьРегламентЗагрузкиДанных,
		|	оду_БазыУчастникиОбмена.ИДБазы КАК ИДБазыИсточник,
		|	оду_БазыУчастникиОбмена.Код КАК КодБазыДанных,
		|	оду_БазыУчастникиОбмена.Сервер + "" : "" + оду_БазыУчастникиОбмена.Код + "" - "" + оду_БазыУчастникиОбмена.ИДКонфигурации + "" ("" + оду_БазыУчастникиОбмена.ИДБазы + "")"" КАК ПредставлениеТекущейБД,
		|	оду_БазыУчастникиОбмена.ИДКонфигурации КАК ИДКонфигурации,
		|	оду_БазыУчастникиОбмена.НастройкаКонвертацииОбмена КАК НастройкаКонвертацииОбмена,
		|	ЕСТЬNULL(оду_НастройкиИнформационнойБазы.chat_id, """") КАК chat_id,
		|	ЕСТЬNULL(оду_НастройкиИнформационнойБазы.token, """") КАК token,
		|	ЕСТЬNULL(оду_НастройкиИнформационнойБазы.Логировать, ЛОЖЬ) КАК Логировать,
		|	ЕСТЬNULL(оду_НастройкиИнформационнойБазы.КаталогОбмена, """") КАК КаталогОбмена,
		|	оду_БазыУчастникиОбмена.ЭтоРабочаяБД КАК ЭтоРабочаяБД,
		//|	оду_НастройкиИнформационнойБазы.ИмяРабочейБД = оду_БазыУчастникиОбмена.Код И оду_НастройкиИнформационнойБазы.СерверРабочейБД = оду_БазыУчастникиОбмена.Сервер КАК ЭтоРабочаяБД, 
		|	оду_БазыУчастникиОбмена.Сервер КАК Сервер,
		|	оду_БазыУчастникиОбмена.Порт КАК Порт,
		|	оду_БазыУчастникиОбмена.Пользователь КАК Пользователь,
		|	оду_БазыУчастникиОбмена.Пароль КАК Пароль,
		|	оду_БазыУчастникиОбмена.ИспользоватьПоддержкуРавныхОстатков КАК ИспользоватьПоддержкуРавныхОстатков,
		|	оду_БазыУчастникиОбмена.ТекущаяБД КАК ТекущаяБД,
		|	ВЫБОР
		|		КОГДА ЕСТЬNULL(оду_НастройкиИнформационнойБазы.КоличествоОбъектовВПакетеОбмена, 0) = 0
		|			ТОГДА 25
		|		ИНАЧЕ оду_НастройкиИнформационнойБазы.КоличествоОбъектовВПакетеОбмена
		|	КОНЕЦ КАК КоличествоОбъектовВПакетеОбмена,
		|	ВЫБОР
		|		КОГДА ЕСТЬNULL(оду_НастройкиИнформационнойБазы.КоличествоПопытокПриОшибке, 0) = 0
		|			ТОГДА 3
		|		ИНАЧЕ оду_НастройкиИнформационнойБазы.КоличествоПопытокПриОшибке
		|	КОНЕЦ КАК КоличествоПопытокПриОшибке
		|ИЗ
		|	Справочник.оду_БазыУчастникиОбмена КАК оду_БазыУчастникиОбмена
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.оду_НастройкиИнформационнойБазы КАК оду_НастройкиИнформационнойБазы
		//|		ПО (оду_НастройкиИнформационнойБазы.БазаДанных = оду_БазыУчастникиОбмена.Ссылка) Настройка всегда одна
		|		ПО Истина 
		|ГДЕ Истина
		|	И оду_БазыУчастникиОбмена.ПометкаУдаления = ЛОЖЬ
		|	#ТекстОтбора
		|";
		
	Если ТипЗнч(СсылкаУО) = Тип("СправочникСсылка.оду_БазыУчастникиОбмена") Тогда
		ТекстОтбора = "И оду_БазыУчастникиОбмена.Ссылка = &СсылкаУО";
		Запрос.УстановитьПараметр("СсылкаУО", СсылкаУО);
	Иначе
		ТекстОтбора = "И оду_БазыУчастникиОбмена.ТекущаяБД = ИСТИНА";
	КонецЕсли; 
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "#ТекстОтбора" ,ТекстОтбора);
	РЗ = Запрос.Выполнить();
	
	Возврат пр_Общий.СтруктураПоЗапросу(РЗ);

КонецФункции // ()

// Возвращает основные настройки узла обмена
// Параметры:
//  НастройкиРегистрации - строка - текст регистрации объектов узла - участника обмена
//  РежимОтладки	- Булево - Признак отладки
//  ПутьКОбработкиОтладки	- Строка - Путь к файловой обработке отладки
//  ИспользоватьОбработкуБСП	- Булево - Обработка берется с ДопОтчетовОбработок
//  ОбработкаОтладкиБСП	- СсылкаОбработки - Ссылка на внешнюю обработку
//  Логировать	- Булево - Признак записи ошибок в телеграмм
//  ЧатТелеграмм - Строка - ИД чата телеграмм
//
// Возвращаемое значение:
//  НастройкиРегистрации   - Структура с полями
//	Неопределено - В случае ошибки
//
Функция НастройкиТекущейБД()  Экспорт 
	
	Возврат НастройкиУчастникаОбмена();

КонецФункции // ()

Функция ПараметрыПодключенияПоСсылкеУО(СсылкаУО)	Экспорт 
	
	Если НЕ ЗначениеЗаполнено(СсылкаУО)  Тогда
		Возврат Неопределено;
	КонецЕсли;

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	оду_БазыУчастникиОбмена.Сервер КАК Сервер,
		|	оду_БазыУчастникиОбмена.Порт КАК Порт,
		|	оду_БазыУчастникиОбмена.Пользователь КАК Пользователь,
		|	оду_БазыУчастникиОбмена.Пароль КАК Пароль,
		|	оду_БазыУчастникиОбмена.Код КАК ИмяБазыПриемника,
		|	оду_БазыУчастникиОбмена.Код КАК ИмяБазыУО,
		|	""/hs/universalExchange/"" КАК ПутьКСервисуHTTP,
		|	оду_БазыУчастникиОбмена.ИДБазы КАК ИДБазыПриемник
		|ИЗ
		|	Справочник.оду_БазыУчастникиОбмена КАК оду_БазыУчастникиОбмена
		|ГДЕ
		|	оду_БазыУчастникиОбмена.Ссылка = &Ссылка
		|	И оду_БазыУчастникиОбмена.ПометкаУдаления = ЛОЖЬ";
	
	Запрос.УстановитьПараметр("Ссылка", СсылкаУО);
	
	РезультатЗапроса = Запрос.Выполнить();
	ПараметрыПодключения = пр_Общий.СтруктураПоЗапросу(РезультатЗапроса);
		
	Возврат ПараметрыПодключения;
	
КонецФункции 

//Функция ЭтаРабочаяБД()   Экспорт 
//	ИмяИБ = оду_ОбменПовтИсп.ПолучитьИмяИнформационнойБазы();
//	ЭтаРабочаяБД = НРег(ИмяИБ) = НРег("baseUT");
//	Возврат ЭтаРабочаяБД;
//КонецФункции 
 
Функция ПолучитьИмяИнформационнойБазы()	Экспорт
	Возврат пр_Общий.ПолучитьИмяИнформационнойБазы();
КонецФункции 

Функция ИДКонфигурации() Экспорт
	
	Возврат пр_Общий.ИДКонфигурации();
	
КонецФункции // ИДКонфигурации()

Функция ПрефиксЭтойИБ()  Экспорт
	Возврат Константы.ПрефиксУзлаРаспределеннойИнформационнойБазы.Получить();
КонецФункции 

Функция СтруктураПараметровЗаписиОшибки() Экспорт
	
	СтруктураПЗО = Новый Структура("ИДОбъекта, ИДБазы, ОбъектОбмена, РежимОбмена, СостояниеОбмена, ИмяФайлаОбмена, НомерПопытки, ОписаниеОшибки"); 	
	Возврат СтруктураПЗО;
	
КонецФункции 

#КонецОбласти

#Область  Ссылки

Функция СсылкаТекущейБД()  Экспорт 

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	оду_НастройкиУчастниковОбмена.Ссылка КАК БазаДанных
		|ИЗ
		|	Справочник.оду_БазыУчастникиОбмена КАК оду_НастройкиУчастниковОбмена
		|ГДЕ
		|	оду_НастройкиУчастниковОбмена.Ссылка.ТекущаяБД = ИСТИНА
		|	И оду_НастройкиУчастниковОбмена.ПометкаУдаления = ЛОЖЬ";
	
	РЗ = Запрос.Выполнить();
	
	Если РЗ.Пустой() Тогда
		Возврат Неопределено;
	КонецЕсли; 
	
	ВДЗ = РЗ.Выбрать();
	
	Если ВДЗ.Следующий() Тогда
		Возврат ВДЗ.БазаДанных;
	КонецЕсли; 

КонецФункции // ()

#Область  РежимыОбмена

Функция РежимЗагрузка()	Экспорт
	Возврат ПредопределенноеЗначение("Перечисление.оду_РежимОбмена.ЗагрузкаДанных");
КонецФункции 

Функция РежимВыгрузка()	Экспорт
	Возврат ПредопределенноеЗначение("Перечисление.оду_РежимОбмена.ВыгрузкаДанных");
КонецФункции 

Функция РежимЗапросСсылки()	Экспорт
	Возврат ПредопределенноеЗначение("Перечисление.оду_РежимОбмена.ЗапросСсылки");
КонецФункции 

Функция РежимЗапросДвижений()	Экспорт
	Возврат ПредопределенноеЗначение("Перечисление.оду_РежимОбмена.ЗапросДвижений");
КонецФункции 

#КонецОбласти

#Область  СостоянияОбмена

Функция СостояниеРазрешениеКоллизий()	Экспорт
	Возврат ПредопределенноеЗначение("Перечисление.оду_СостоянияОбмена.РазрешениеКоллизий");
КонецФункции 

Функция СостояниеПроверкаДанных()	Экспорт
	Возврат ПредопределенноеЗначение("Перечисление.оду_СостоянияОбмена.ПроверкаДанных");
КонецФункции 

Функция СостояниеВыгрузка()	Экспорт
	Возврат ПредопределенноеЗначение("Перечисление.оду_СостоянияОбмена.Выгрузка");
КонецФункции 

Функция СостояниеВыгружен()	Экспорт
	Возврат ПредопределенноеЗначение("Перечисление.оду_СостоянияОбмена.Выгружен");
КонецФункции 

Функция СостояниеЗагрузка()	Экспорт
	Возврат ПредопределенноеЗначение("Перечисление.оду_СостоянияОбмена.Загрузка");
КонецФункции 

Функция СостояниеЗагружен()	Экспорт
	Возврат ПредопределенноеЗначение("Перечисление.оду_СостоянияОбмена.Загружен");
КонецФункции 

#КонецОбласти

#Область  КонфигурацииКД

Функция КонфигурацияКД2()	Экспорт
	Возврат ПредопределенноеЗначение("Перечисление.оду_КонфигурацияКонвертацииДанных.КД2");
КонецФункции 

Функция КонфигурацияКД3()	Экспорт
	Возврат ПредопределенноеЗначение("Перечисление.оду_КонфигурацияКонвертацииДанных.КД3");
КонецФункции 

Функция КонфигурацияПроизвольная()	Экспорт
	Возврат ПредопределенноеЗначение("Перечисление.оду_КонфигурацияКонвертацииДанных.Произвольная");
КонецФункции 

#КонецОбласти
 
#КонецОбласти

#Область  Обмен

//TODO: 
//Подумать как встроить, надстроить рабочую обработку обмена данными
Функция ОбработкаОбменаДанныхКД2(ПОД = "", РежимОтладки = Ложь, ПутьКПОД = "") Экспорт 
	
	Если РежимОтладки = Ложь Тогда
		ОбработкаОбменаДанных = Обработки.оду_УниверсальныйОбменДаннымиXML.Создать();
	Иначе
		//TODO:  
		ПолныйПуть = "\\pivo.local\Resource\Личные\Кириллов ПС\r\work\оду_УниверсальныйОбменДаннымиXML.epf";
		ОбработкаОбменаДанных = пр_Общий.ПолучитьВнешнююОбработкуПоПути(ПолныйПуть);
	КонецЕсли; 
	
	Если ПОД = "" Тогда //Режим загрузки
		Возврат ОбработкаОбменаДанных;
	КонецЕсли; 
	
	ТекстСообщения = "";
	
	Если ТипЗнч(ПОД) = Тип("Строка") Тогда
		ОбработкаОбменаДанных.ЗагрузитьПравилаОбмена(ПОД, "Строка");
		
		Если ПутьКПОД = "" Тогда
			ПутьКПОД = "УОД.xml";
		КонецЕсли;
		ОбработкаОбменаДанных.ИмяФайлаПравилОбмена = ПутьКПОД;
	//ИначеЕсли ТипЗнч(ПОД) = Тип("ТекстовыйДокумент") Тогда
	//	ПОД.Записать(ОбработкаВыгрузкиДанных.ИмяФайлаПравилОбмена);
	КонецЕсли; 
	
	Если ОбработкаОбменаДанных.ФлагОшибки Тогда
		ТекстСообщения = НСтр("ru = 'Ошибка при загрузке правил переноса данных.'");
	КонецЕсли;	
	
	Если НЕ ПустаяСтрока(ТекстСообщения) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	// Параметры переноса
	ОбработкаОбменаДанных.ВыгружатьТолькоРазрешенные                      		= Ложь;
	ОбработкаОбменаДанных.ФлагРежимОтладки                                		= Ложь;
	ОбработкаОбменаДанных.ВыполнитьОбменДаннымиВОптимизированномФормате   		= Истина;
	ОбработкаОбменаДанных.НепосредственноеЧтениеВИБПриемнике             		= Ложь;
	ОбработкаОбменаДанных.ВерсияПлатформыИнформационнойБазыДляПодключения 		= "V83";
	ОбработкаОбменаДанных.НеВыводитьНикакихИнформационныхСообщенийПользователю  = Истина;
	ОбработкаОбменаДанных.ИспользоватьОтборПоДатеДляВсехОбъектов				= Ложь;
	//Доп 
	//ОбработкаОбменаДанных.Данные												= Ложь; //???
	ОбработкаОбменаДанных.ИспользоватьТранзакции								= Истина;
	ОбработкаОбменаДанных.КоличествоОбъектовНаТранзакцию						= 100;
	ОбработкаОбменаДанных.ЭтоИнтерактивныйРежим									= Ложь;
		
	МассивПравилВыгрузки = Новый Массив();
	ИзменитьДеревоПравилВыгрузки(ОбработкаОбменаДанных.ТаблицаПравилВыгрузки.Строки, , "УниверсальноеПВД", МассивПравилВыгрузки);
	
	//Передается массив структур (ИмяТипаСсылки и Массив по этому типу)
	ОбработкаОбменаДанных.Комментарий = "оду_ВыгрузкаИзРегистрации";
	
	СтруктураДанных = Новый Структура("ТекущаяСтрокаПравилаВыгрузки, СоответвиеПараметровВыгрузки, ТаблицаСостоянийОбмена",
										МассивПравилВыгрузки[0], Неопределено, Неопределено); 
	ОбработкаОбменаДанных.Данные = СтруктураДанных;
	
	Возврат ОбработкаОбменаДанных;
	
КонецФункции 


Процедура ИзменитьДеревоПравилВыгрузки(СтрокиИсходногоДерева, РодительПВД = "", ИмяПВД, МассивПравилВыгрузки)
	
	Для Каждого СтрокаИсходногоДерева Из СтрокиИсходногоДерева Цикл
		
		Если СтрокаИсходногоДерева.Имя = РодительПВД Тогда
			СтрокаИсходногоДерева.Включить = 2;
		ИначеЕсли  СтрокаИсходногоДерева.Имя = ИмяПВД Тогда	
			СтрокаИсходногоДерева.Включить = 1;
			МассивПравилВыгрузки.Добавить(СтрокаИсходногоДерева);
		Иначе 
			СтрокаИсходногоДерева.Включить = 0;
		КонецЕсли;
		
		Если СтрокаИсходногоДерева.Строки.Количество() > 0 Тогда
			ИзменитьДеревоПравилВыгрузки(СтрокаИсходногоДерева.Строки, РодительПВД, ИмяПВД, МассивПравилВыгрузки);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры


Функция ТекстЗапросаПолученияМассиваУчастниковОбменаПоТипуОбъекта(ЭтоСамолет = Ложь)
	
	ТекстЗапроса = 
		"ВЫБРАТЬ
		|	оду_БазыУчастникиОбменаСостав.Ссылка КАК БазаПриемник,
		|	ВЫБОР
		|		КОГДА ЕСТЬNULL(оду_БазыУчастникиОбменаСостав.ПравилоРегистрации, ЗНАЧЕНИЕ(Справочник.оду_ПравилаРегистрацииОбмена.ПустаяСсылка)) <> ЗНАЧЕНИЕ(Справочник.оду_ПравилаРегистрацииОбмена.ПустаяСсылка)
		|				И оду_БазыУчастникиОбменаСостав.ПравилоРегистрации.ПометкаУдаления = ЛОЖЬ
		|				И оду_БазыУчастникиОбменаСостав.ПравилоРегистрации.Используется = ИСТИНА
		|			ТОГДА оду_БазыУчастникиОбменаСостав.ПравилоРегистрации
		|		ИНАЧЕ оду_БазыУчастникиОбменаСостав.Ссылка.ПравилоРегистрации
		|	КОНЕЦ КАК НастройкаПравилаРегистрации,
		|	ВЫБОР
		|		КОГДА ЕСТЬNULL(оду_БазыУчастникиОбменаСостав.НастройкаКонвертацииОбмена, ЗНАЧЕНИЕ(Справочник.оду_НастройкаКонвертацииДанных.ПустаяСсылка)) <> ЗНАЧЕНИЕ(Справочник.оду_НастройкаКонвертацииДанных.ПустаяСсылка)
		|				И оду_БазыУчастникиОбменаСостав.НастройкаКонвертацииОбмена.ПометкаУдаления = ЛОЖЬ
		|			ТОГДА оду_БазыУчастникиОбменаСостав.НастройкаКонвертацииОбмена
		|		ИНАЧЕ оду_БазыУчастникиОбменаСостав.Ссылка.НастройкаКонвертацииОбмена
		|	КОНЕЦ КАК НастройкаКонвертацииОбмена,
		|	оду_БазыУчастникиОбменаСостав.ТипXMLОбъектаИсточника КАК ТипXMLОбъектаИсточника,
		|	оду_БазыУчастникиОбменаСостав.ТипXMLОбъектаПриемника КАК ТипXMLОбъектаПриемника,
		|	оду_БазыУчастникиОбменаСостав.Ссылка.ИДБазы КАК ИДБазыПриемник,
		|	оду_БазыУчастникиОбменаСостав.Ссылка.ИДКонфигурации КАК ИДКонфигурации,
		|	оду_БазыУчастникиОбменаСостав.Ссылка.ЭтоРабочаяБД КАК ЭтоРабочаяБД,
		|	оду_БазыУчастникиОбменаСостав.НомерСтроки КАК ПриоритетОбъекта,
		|	оду_БазыУчастникиОбменаСостав.Объект.Родитель.Наименование КАК МетаданныеНаименование,
		|	оду_БазыУчастникиОбменаСостав.Ссылка.ПриоритетОбмена КАК ПриоритетОбмена,
		|	оду_БазыУчастникиОбменаСостав.Ссылка.РежимОтладки КАК РежимОтладки
		|ПОМЕСТИТЬ ВТ_Настройки
		|ИЗ
		|	Справочник.оду_БазыУчастникиОбмена.Состав КАК оду_БазыУчастникиОбменаСостав
		|ГДЕ
		|	оду_БазыУчастникиОбменаСостав.ТипXMLОбъектаИсточника = &ТипXML
		|	И оду_БазыУчастникиОбменаСостав.Ссылка.Используется = ИСТИНА
		|	И оду_БазыУчастникиОбменаСостав.Ссылка.ПометкаУдаления = ЛОЖЬ
		|	И оду_БазыУчастникиОбменаСостав.Ссылка.ТекущаяБД = ЛОЖЬ
		|	И ВЫБОР
		|			КОГДА оду_БазыУчастникиОбменаСостав.Ссылка.ЭтоРабочаяБД = ИСТИНА
		|					И &ТекущаяРабочаяБД = ЛОЖЬ
		|				ТОГДА ЛОЖЬ
		|			ИНАЧЕ ИСТИНА
		|		КОНЕЦ
		|	#Отбор
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТ_Настройки.БазаПриемник КАК БазаПриемник,
		|	ВТ_Настройки.РежимОтладки КАК РежимОтладки,
		|	ВТ_Настройки.НастройкаПравилаРегистрации КАК НастройкаПравилаРегистрации,
		|	ЕСТЬNULL(ВЫБОР
		|			КОГДА ЕСТЬNULL(ВТ_Настройки.НастройкаПравилаРегистрации.РежимОтладки, ЛОЖЬ) = ИСТИНА
		|				ТОГДА ВЫБОР
		|						КОГДА ВТ_Настройки.НастройкаПравилаРегистрации.ИспользоватьОбработкуБСП = ИСТИНА
		|							ТОГДА ВТ_Настройки.НастройкаПравилаРегистрации.ОбработкаОтладкиБСП
		|						ИНАЧЕ ВТ_Настройки.НастройкаПравилаРегистрации.ПутьКОбработкиОтладки
		|					КОНЕЦ
		|			ИНАЧЕ НЕОПРЕДЕЛЕНО
		|		КОНЕЦ, НЕОПРЕДЕЛЕНО) КАК ОбработкаРегистрации,
		|	ЕСТЬNULL(ВТ_Настройки.НастройкаПравилаРегистрации.ПравилоРегистрации, """") КАК ПравилоРегистрации,
		|	ВТ_Настройки.НастройкаКонвертацииОбмена КАК НастройкаКонвертацииОбмена,
		|	ЕСТЬNULL(ВТ_Настройки.НастройкаКонвертацииОбмена.РежимОтладки, ЛОЖЬ) КАК РежимОтладкиКД,
		|	ЕСТЬNULL(ВЫБОР
		|			КОГДА ЕСТЬNULL(ВТ_Настройки.НастройкаКонвертацииОбмена.РежимОтладки, ЛОЖЬ) = ИСТИНА
		|				ТОГДА ВЫБОР
		|						КОГДА ВТ_Настройки.НастройкаКонвертацииОбмена.ИспользоватьОбработкуБСП = ИСТИНА
		|							ТОГДА ВТ_Настройки.НастройкаКонвертацииОбмена.ОбработкаОтладкиБСП
		|						ИНАЧЕ ВТ_Настройки.НастройкаКонвертацииОбмена.ПутьКОбработкиОтладки
		|					КОНЕЦ
		|			ИНАЧЕ НЕОПРЕДЕЛЕНО
		|		КОНЕЦ, НЕОПРЕДЕЛЕНО) КАК ОбработкаОтладки,
		|	ВТ_Настройки.ТипXMLОбъектаИсточника КАК ТипXMLОбъектаИсточника,
		|	ВТ_Настройки.ТипXMLОбъектаПриемника КАК ТипXMLОбъектаПриемника,
		|	ВТ_Настройки.ИДБазыПриемник КАК ИДБазыПриемник,
		|	ВТ_Настройки.ИДКонфигурации КАК ИДКонфигурации,
		|	ВТ_Настройки.ЭтоРабочаяБД КАК ЭтоРабочаяБД,
		|	&ТекущаяРабочаяБД КАК ТекущаяБДРабочая,
		|	ВТ_Настройки.ПриоритетОбъекта КАК ПриоритетОбъекта,
		|	ВТ_Настройки.МетаданныеНаименование КАК МетаданныеНаименование,
		|	ВТ_Настройки.ПриоритетОбмена КАК ПриоритетОбмена,
		|	&КоличествоОбъектовВПакетеОбмена КАК КоличествоОбъектовВПакетеОбмена,
		|	&КоличествоПопытокПриОшибке КАК КоличествоПопытокПриОшибке,
		|	&ИДКонфигурацииТекущейБД КАК ИДКонфигурацииТекущейБД,
		|	&ТипXML КАК ИмяТипаXML,
		|	&КаталогОбмена КАК КаталогОбмена,
		|	ВТ_Настройки.БазаПриемник.Организации.(
		|		Организация КАК Организация,
		|		ТипXMLОбъектаИсточника КАК ТипXMLОбъектаИсточника,
		|		ИДОбъектаИсточника КАК ИДОбъектаИсточника,
		|		ТипXMLОбъектаПриемника КАК ТипXMLОбъектаПриемника,
		|		ИДОбъектаПриемника КАК ИДОбъектаПриемника
		|	) КАК select
		|ИЗ
		|	ВТ_Настройки КАК ВТ_Настройки
		|
		|УПОРЯДОЧИТЬ ПО
		|	ПриоритетОбмена
		|";             
	
	Если ЭтоСамолет = Ложь Тогда
		Отбор = "И оду_БазыУчастникиОбменаСостав.Регистрировать = ИСТИНА";
	Иначе
		Отбор = "И оду_БазыУчастникиОбменаСостав.ИспользоватьСамолет = ИСТИНА";
	КонецЕсли;

	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "#Отбор", Отбор);
	
	Возврат ТекстЗапроса;

КонецФункции

//Участником регистрации может быть только Рабочие базы,
//Самолетом с рабочей можено выгружать в любую, из тестовых - только в тестовые
Функция МассивУчастниковОбменаПоТипуОбъекта(ТипXML, НастройкиТекущейБД, ЭтоСамолет = Ложь) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапросаПолученияМассиваУчастниковОбменаПоТипуОбъекта(ЭтоСамолет);
	
	Запрос.УстановитьПараметр("ТипXML", ТипXML);
	Запрос.УстановитьПараметр("КоличествоОбъектовВПакетеОбмена", НастройкиТекущейБД.КоличествоОбъектовВПакетеОбмена);
	Запрос.УстановитьПараметр("КоличествоПопытокПриОшибке", НастройкиТекущейБД.КоличествоПопытокПриОшибке);
	Запрос.УстановитьПараметр("КаталогОбмена", НастройкиТекущейБД.КаталогОбмена);
	Запрос.УстановитьПараметр("ТекущаяРабочаяБД", НастройкиТекущейБД.ЭтоРабочаяБД);
	Запрос.УстановитьПараметр("ИДКонфигурацииТекущейБД", НастройкиТекущейБД.ИДКонфигурации);
	
	УстановитьПривилегированныйРежим(Истина);
	РЗ = Запрос.Выполнить(); 
	
	Если РЗ.Пустой() Тогда
		Возврат Неопределено;
	КонецЕсли; 
	
	ВДЗ = РЗ.Выбрать();
	
	МассивУчастниковОбмена = Новый Массив;
						   
	Пока ВДЗ.Следующий() Цикл
		
		СтруктураНастроек = пр_Общий.СтруктураПоЗапросу(ВДЗ);
		СтруктураНастроек.Удалить("select");
		
		//select = пр_Общий.МассивСтруктурПоЗапросу(ВДЗ.select);
		
		ВыборкаОргашизаций = ВДЗ.select.Выбрать();
		//ВыборкаОргашизаций.Сбросить();
		select = Новый Массив;
			   
		Пока ВыборкаОргашизаций.Следующий() Цикл
			select.Добавить(ВыборкаОргашизаций.Организация);	
		КонецЦикла;
		
		СтруктураНастроек.Вставить("select", select);  
		ЕстьОграничениеНаОрганизации = select.Количество() > 0;
		СтруктураНастроек.Вставить("ЕстьОграничениеНаОрганизации", ЕстьОграничениеНаОрганизации);
		
		МассивУчастниковОбмена.Добавить(СтруктураНастроек);
		
	КонецЦикла;

	Возврат МассивУчастниковОбмена;
	
КонецФункции 


Функция ПриоритетОбъектаОбмена(ТипXML, ПризнакПриоритета) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	оду_НастрокаПриоритетаОбъектаОбмена.ПриоритетОбъекта КАК ПриоритетОбъекта
		|ИЗ
		|	РегистрСведений.оду_НастрокаПриоритетаОбъектаОбмена КАК оду_НастрокаПриоритетаОбъектаОбмена
		|ГДЕ
		|	оду_НастрокаПриоритетаОбъектаОбмена.ТипXML = &ТипXML
		|	И оду_НастрокаПриоритетаОбъектаОбмена.ПризнакПриоритета = &ПризнакПриоритета";
	
	Запрос.УстановитьПараметр("ТипXML", ТипXML);
	Запрос.УстановитьПараметр("ПризнакПриоритета", ПризнакПриоритета);
	
	РЗ = Запрос.Выполнить();
	
	Если РЗ.Пустой() Тогда
		Возврат 999999;
	КонецЕсли; 
	
	ВДЗ = РЗ.Выбрать();
	
	Если ВДЗ.Следующий() Тогда
		Возврат ВДЗ.ПриоритетОбъекта;
	КонецЕсли; 
	
КонецФункции 

//УО - Ссылка - оду_БазыУчастникиОбмена
Функция ДанныеОбУчастникахОбмена(НастройкиТекущейБД = Неопределено, СсылкаУО = Неопределено)	Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	оду_БазыУчастникиОбмена.Ссылка КАК БазаДанных,
		|	оду_БазыУчастникиОбмена.Сервер + "" : "" + оду_БазыУчастникиОбмена.Код + "" - "" + оду_БазыУчастникиОбмена.ИДКонфигурации + "" ("" + оду_БазыУчастникиОбмена.ИДБазы + "")"" КАК ПредставлениеБД,
		|	оду_БазыУчастникиОбмена.ИспользоватьРегламентВыгрузкиДанных КАК ИспользоватьРегламентВыгрузкиДанных,
		|	оду_БазыУчастникиОбмена.ИспользоватьРегламентЗагрузкиДанных КАК ИспользоватьРегламентЗагрузкиДанных,
		|	оду_БазыУчастникиОбмена.ИДБазы КАК ИДБазыПриемник,
		|	оду_БазыУчастникиОбмена.Код КАК ИмяБазыПриемника,
		|	оду_БазыУчастникиОбмена.Код КАК ИмяБазыУО,
		|	оду_БазыУчастникиОбмена.ЭтоРабочаяБД КАК ЭтоРабочаяБД,
		|	оду_БазыУчастникиОбмена.Сервер КАК Сервер,
		|	оду_БазыУчастникиОбмена.Порт КАК Порт,
		|	оду_БазыУчастникиОбмена.Пользователь КАК Пользователь,
		|	оду_БазыУчастникиОбмена.Пароль КАК Пароль,
		|	""/hs/universalExchange/"" КАК ПутьКСервисуHTTP,
		|	&ТекущаяРабочаяБД КАК ТекущаяБДРабочая,
		|	&КоличествоОбъектовВПакетеОбмена КАК КоличествоОбъектовВПакетеОбмена,
		|	&КоличествоПопытокПриОшибке КАК КоличествоПопытокПриОшибке,
		|	&ИДКонфигурацииТекущейБД КАК ИДКонфигурацииТекущейБД,
		|	&КаталогОбмена КАК КаталогОбмена
		|ИЗ
		|	Справочник.оду_БазыУчастникиОбмена КАК оду_БазыУчастникиОбмена
		|ГДЕ
		|	оду_БазыУчастникиОбмена.ТекущаяБД = ЛОЖЬ
		|	И оду_БазыУчастникиОбмена.ПометкаУдаления = ЛОЖЬ
		|	И ВЫБОР
		|			КОГДА оду_БазыУчастникиОбмена.ЭтоРабочаяБД = ИСТИНА
		|					И &ТекущаяРабочаяБД = ЛОЖЬ
		|				ТОГДА ЛОЖЬ
		|			ИНАЧЕ ИСТИНА
		|		КОНЕЦ
		|	И оду_БазыУчастникиОбмена.Используется = ИСТИНА
		|	#ДопОтбор
		|
		|УПОРЯДОЧИТЬ ПО
		|	оду_БазыУчастникиОбмена.ПриоритетОбмена
		|";
	Если СсылкаУО = Неопределено Тогда
		ДопОтбор = "";
	Иначе 	
		ДопОтбор = "И оду_БазыУчастникиОбмена.Ссылка = &Ссылка";
		Запрос.УстановитьПараметр("Ссылка", СсылкаУО);
	КонецЕсли;
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "#ДопОтбор", ДопОтбор);
	
	Если НастройкиТекущейБД = Неопределено Тогда
		НастройкиТекущейБД = оду_ОбщийПовтИсп.НастройкиТекущейБД();
	КонецЕсли;
	
	Запрос.УстановитьПараметр("КоличествоОбъектовВПакетеОбмена", НастройкиТекущейБД.КоличествоОбъектовВПакетеОбмена);
	Запрос.УстановитьПараметр("КоличествоПопытокПриОшибке", НастройкиТекущейБД.КоличествоПопытокПриОшибке);
	Запрос.УстановитьПараметр("КаталогОбмена", НастройкиТекущейБД.КаталогОбмена);
	Запрос.УстановитьПараметр("ТекущаяРабочаяБД", НастройкиТекущейБД.ЭтоРабочаяБД);
	Запрос.УстановитьПараметр("ИДКонфигурацииТекущейБД", НастройкиТекущейБД.ИДКонфигурации);
	
	РЗ = Запрос.Выполнить();
	
	//ВыборкаУО = РезультатЗапроса.Выбрать();
	//Возврат ВыборкаУО;
	//Если СсылкаУО = Неопределено Тогда
		Возврат пр_Общий.МассивСтруктурПоЗапросу(РЗ); 
	//Иначе
	//	Возврат пр_Общий.СтруктураПоЗапросу(РЗ); 
	//КонецЕсли; 
	//
КонецФункции 

Функция НастройкиЛогированияТелеграм()  Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	оду_НастройкиИнформационнойБазы.Логировать КАК Логировать,
		|	оду_НастройкиИнформационнойБазы.chat_id КАК chat_id,
		|	оду_НастройкиИнформационнойБазы.token КАК token
		|ИЗ
		|	РегистрСведений.оду_НастройкиИнформационнойБазы КАК оду_НастройкиИнформационнойБазы
		|ГДЕ
		|	оду_НастройкиИнформационнойБазы.chat_id <> """"
		|	И оду_НастройкиИнформационнойБазы.token <> """"";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Возврат пр_Общий.СтруктураПоЗапросу(РезультатЗапроса);
	
КонецФункции 

//	КонфигурацияКонвертацииОбмена
//	ПОДИзФайла
//	ПутьКПОД
//	ПОДИзОбработкиБСП
//	ОбработкаОтладкиБСП
//	ПОД
//	РежимОтладки
Функция ПараметрыКонвертацииОбъекта()  Экспорт
	
	ПараметрыКонвертации = Новый Структура();
	ПараметрыКонвертации.Вставить("УО");
	ПараметрыКонвертации.Вставить("ДанныеОбмена");
	ПараметрыКонвертации.Вставить("КонфигурацияКонвертацииОбмена", Неопределено);
	ПараметрыКонвертации.Вставить("РежимОтладки", Ложь);
	ПараметрыКонвертации.Вставить("ПОДИзФайла", Ложь);
	ПараметрыКонвертации.Вставить("ПутьКПОД", "");
	ПараметрыКонвертации.Вставить("ПОДИзОбработкиБСП", Ложь);
	ПараметрыКонвертации.Вставить("ОбработкаОтладкиБСП", Неопределено);
	ПараметрыКонвертации.Вставить("ИспользоватьНастройкиКонвертации", Ложь);
	ПараметрыКонвертации.Вставить("ВыгрузкаБезПроверкиРегистрации", Ложь);  //TODO:  Доделать проверку при выгрузке, когда выгрузка происходит сразу - чз обработку, без регистрации
	ПараметрыКонвертации.Вставить("НастройкаКонвертации", Неопределено);
	ПараметрыКонвертации.Вставить("ПОД", "");
	
	Возврат  ПараметрыКонвертации;
	
КонецФункции 

Функция ПараметрыПодключенияУО()	Экспорт 
	
	ПараметрыПодключения = Новый Структура("Сервер, Порт, Пользователь, Пароль, ИмяБазыПриемника, ПутьКСервисуHTTP, ИДБазыПриемник, ИмяБазыУО");
	ПараметрыПодключения.ПутьКСервисуHTTP = "/hs/universalExchange/";
	
	Возврат ПараметрыПодключения;
	
КонецФункции 

#КонецОбласти

//ОМ.оду_ОбщийПовтИсп