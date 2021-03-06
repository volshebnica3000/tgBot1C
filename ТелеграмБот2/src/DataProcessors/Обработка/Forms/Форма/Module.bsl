&НаСервереБезКонтекста
Процедура СообщитьНаСервере(Chat_id, Token, ТекстСообщения)
	
	Соединение = Новый HTTPСоединение("api.telegram.org", 443,,,,,Новый ЗащищенноеСоединениеOpenSSL()); 
	ПараметрыЗапроса = СтрШаблон("?chat_id=%1&text=%2", Формат(Chat_id, "ЧГ=0"), КодироватьСтроку(ТекстСообщения,СпособКодированияСтроки.КодировкаURL));

	ТекстЗапросаHTTP = СтрШаблон( "bot%1/sendMessage%2", Token, ПараметрыЗапроса );

	Запрос = Новый HTTPЗапрос(ТекстЗапросаHTTP);
	Соединение.ОтправитьДляОбработки(Запрос);
КонецПроцедуры

Процедура ОтправитьГифНаСервер(Chat_id, Token, Животное)
	
	Соединение = Новый HTTPСоединение("api.telegram.org", 443,,,,5,Новый ЗащищенноеСоединениеOpenSSL()); 
	
	Если Животное="Крыса" Тогда
		Данные = Новый ДвоичныеДанные("C:/Users/sergeeva.o/Documents/BaseTG2/gif/rat/rat3.gif");
	ИначеЕсли Животное = "Кошка" Тогда
		Данные = Новый ДвоичныеДанные("C:/Users/sergeeva.o/Documents/BaseTG2/gif/cat/cat1.gif");
	ИначеЕсли Животное = "Собака" Тогда
		Данные = Новый ДвоичныеДанные("C:/Users/sergeeva.o/Documents/BaseTG2/gif/dog/dog1.gif");
	КонецЕсли;
	
	Разделитель = "----" + Строка(Новый УникальныйИдентификатор());
	
	Поток = Новый ПотокВПамяти;	
	ЗаписьДанных = Новый ЗаписьДанных(Поток);
	ЗаписьДанных.ЗаписатьСтроку("--" + Разделитель);
    ЗаписьДанных.ЗаписатьСтроку("Content-Disposition: form-data; name=""animation""; filename=""pic.gif""");
	ЗаписьДанных.ЗаписатьСтроку("");
    ЗаписьДанных.Записать(Данные);
	ЗаписьДанных.ЗаписатьСтроку("");
	ЗаписьДанных.ЗаписатьСтроку("--" + Разделитель);
	ЗаписьДанных.ЗаписатьСтроку("Content-Disposition: form-data; name=""chat_id""");
	ЗаписьДанных.ЗаписатьСтроку("");
	ЗаписьДанных.ЗаписатьСтроку(Chat_id);
	ЗаписьДанных.ЗаписатьСтроку( "--" + Разделитель + "--");	 	 
    ЗаписьДанных.Закрыть();
    
    Заголовки = Новый Соответствие();
	Заголовки.Вставить("Content-Type", "multipart/form-data, boundary=" + Разделитель);
	
	ТекстЗапросаHTTP = 	 СтрШаблон("bot%1/sendAnimation", Token);   
							
	Запрос = Новый HTTPЗапрос(ТекстЗапросаHTTP, Заголовки);						
	Запрос.УстановитьТелоИзДвоичныхДанных(Поток.ЗакрытьИПолучитьДвоичныеДанные());
	
	Соединение.ОтправитьДляОбработки(Запрос);
	
КонецПроцедуры

&НаКлиенте
Процедура НапомнитьОбОтчете(Команда)
	СообщитьНаСервере("@sms1Csergeeva", "5001917870:AAEdpAB9Chl0p-HMnfFQkandz-XKT4kTpRY" ,"Необходимо сдать отчет!");
КонецПроцедуры

&НаКлиенте
Процедура ГифкаСКошкой(Команда)
	ОтправитьГифНаСервер("@sms1Csergeeva", "5001917870:AAEdpAB9Chl0p-HMnfFQkandz-XKT4kTpRY", "Кошка");
КонецПроцедуры

&НаКлиенте
Процедура ГифкаСКрысой(Команда)
	ОтправитьГифНаСервер("@sms1Csergeeva", "5001917870:AAEdpAB9Chl0p-HMnfFQkandz-XKT4kTpRY", "Крыса");	
КонецПроцедуры
	
&НаКлиенте
Процедура ГифкаССобакой(Команда)
	ОтправитьГифНаСервер("@sms1Csergeeva", "5001917870:AAEdpAB9Chl0p-HMnfFQkandz-XKT4kTpRY", "Собака");
КонецПроцедуры

Функция ПолучитьСведенияОПогоде(Город, КлючAPI);
	
	Соединение = Новый HTTPСоединение("api.openweathermap.org", 443,,,,,Новый ЗащищенноеСоединениеOpenSSL()); 
	ТекстЗапросаHTTP = СтрШаблон("data/2.5/weather?q=%1&appid=%2&units=metric&lang=ru", Город, КлючAPI);
							
	Запрос = Новый HTTPЗапрос(ТекстЗапросаHTTP);
	Ответ = Соединение.Получить(Запрос);
	ОтветСтрока = Ответ.ПолучитьТелоКакСтроку();
	
	ЧтениеJSON = Новый ЧтениеJSON();
	ЧтениеJSON.УстановитьСтроку(ОтветСтрока);
	Данные = ПрочитатьJSON(ЧтениеJSON, Истина);
	ЧтениеJSON.Закрыть();
	
	Main = Данные.Получить("main");
	Градусы = Окр(Число(Main.Получить("temp")));
	ГрадусыПоОщущениям = Окр(Число(Main.Получить("feels_like")));
	Weather = Данные.Получить("weather");
	ОписаниеПогоды = Weather[0].Получить("description");
	Влажность = Main.Получить("humidity");
	Wind = Данные.Получить("wind");
	СкоростьВетра = Wind.Получить("speed");
	НазваниеГорода = Данные.Получить("name");
	
	СведенияОПогоде = СтрШаблон("В городе %1 сейчас %2, %3 ℃, ощущается как %4 ℃, скорость ветра %5  м/с, влажность воздуха %6 процентов", НазваниеГорода, ОписаниеПогоды, Градусы, ГрадусыПоОщущениям, СкоростьВетра, Влажность);

	Возврат СведенияОПогоде;
	
КонецФункции
	
&НаКлиенте
Процедура Погода(Команда)
	СведенияОПогоде = ПолучитьСведенияОПогоде("Arkhangelsk", "30e5c4154301634d64a91c0104b3ce68");
	СообщитьНаСервере("@sms1Csergeeva", "5001917870:AAEdpAB9Chl0p-HMnfFQkandz-XKT4kTpRY" , СведенияОПогоде);
КонецПроцедуры
