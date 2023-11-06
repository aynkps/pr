
#Область  Регистрация


Процедура ЗарегистрироватьИзменениеОбъекта(Источник, Отказ, СтруктураНастроекОбмена) Экспорт
	
	Модуль = пр_НастройкиПовтИсп.ИсполняемыйМодуль("оду_Общий", пр_НастройкиПовтИсп.ТекущийПользователь()); 
	РезультатРегистрацииОбъектаОбмена = Истина;
	
	Если СтруктураНастроекОбмена.МетаданныеНаименование = "Документы" Тогда
		//Свойства
	
	Иначе //не доки
		РезультатРегистрацииОбъектаОбмена = Модуль.РезультатРегистрацииОбъектаОбмена(СтруктураНастроекОбмена);
	КонецЕсли; 
	
	//TODO:  подумать, нужно ли запрещать изменять объект, если не удалось зарегать
	Если РезультатРегистрацииОбъектаОбмена = Ложь Тогда
		
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Не удалось зарегистрировать объект обмена";
		Сообщение.Сообщить(); 
		Отказ = Истина;	
	
	КонецЕсли; 
	
КонецПроцедуры 

#КонецОбласти
