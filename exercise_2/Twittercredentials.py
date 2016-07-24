import tweepy

consumer_key = "G2VZXRwJYXjnZNhiwHUNj45r6";
#eg: consumer_key = "YisfFjiodKtojtUvW4MSEcPm";


consumer_secret = "1ZHn56ryRK6o02rTjjKBtSNGJ3wW4VkQacoGQRyRUOmNieiv8A";
#eg: consumer_secret = "YisfFjiodKtojtUvW4MSEcPmYisfFjiodKtojtUvW4MSEcPmYisfFjiodKtojtUvW4MSEcPm";

access_token = "756482946844856320-hC6U2Zx4CVvQtJTFYIGquSjpUaxL9eo";
#eg: access_token = "YisfFjiodKtojtUvW4MSEcPmYisfFjiodKtojtUvW4MSEcPmYisfFjiodKtojtUvW4MSEcPm";

access_token_secret = "6Wf2ClBZObNHkeas3t8WY1Y7JFM1E8Ag1N3wQv2MveNHn";
#eg: access_token_secret = "YisfFjiodKtojtUvW4MSEcPmYisfFjiodKtojtUvW4MSEcPmYisfFjiodKtojtUvW4MSEcPm";


auth = tweepy.OAuthHandler(consumer_key, consumer_secret)
auth.set_access_token(access_token, access_token_secret)

api = tweepy.API(auth)



