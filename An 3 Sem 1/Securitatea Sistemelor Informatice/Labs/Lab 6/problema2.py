import secrets
import string
import hashlib


def parola_a():
    # generez 4 string-uri pentru fiecare tip de caracter:
    alphabet_lc = string.ascii_lowercase
    alphabet_uc = string.ascii_uppercase
    digits = string.digits
    # special_chars = "~!@#$%^&*()_+{}|:<>?,./;[]"
    special_chars = ".!?@"

    # generez o parola de 10 caractere formata cu caractere alese din toate cele 4 stringuri
    password = ''.join(secrets.choice(alphabet_lc + alphabet_uc + digits + special_chars) for i in range(10))

    # ma asigur ca exista minim o litera mica
    index = secrets.randbelow(len(password))
    password = password[:index] + secrets.choice(alphabet_lc) + password[index:]

    # ma asigur ca exista minim o litera mare
    index = secrets.randbelow(len(password))
    password = password[:index] + secrets.choice(alphabet_uc) + password[index:]

    # ma asigur ca exista minim o cifra
    index = secrets.randbelow(len(password))
    password = password[:index] + secrets.choice(digits) + password[index:]

    # ma asigur ca exista minim un caracter special
    index = secrets.randbelow(len(password))
    password = password[:index] + secrets.choice(special_chars) + password[index:]

    return password


def url_safe_b():
    # # un string URL-safe este format din litere, cifre si caracterele -._~
    # alphabet = string.ascii_letters + string.digits + "-._~"
    # # 32 + x va fi lungimea URL-ului, unde x poate fi orice nr. natural intre 0 si 8.
    # # Deci string-ul va avea maxim lungimea 40
    # x = secrets.randbelow(9)
    # url = ''.join(secrets.choice(alphabet) for i in range(32 + x))
    # return url

    url = secrets.token_urlsafe(25)  # url-ul va avea lungime 34
    return url


def hex_token_c():
    # # un token hexazecimal este format din cifre si literele de la A la F
    # alphabet = string.digits + "abcdef"
    # # 32 + x va fi lungimea URL-ului, unde x poate fi orice nr. natural intre 0 si 8.
    # # Deci string-ul va avea maxim lungimea 40
    # x = secrets.randbelow(9)
    # token = ''.join(secrets.choice(alphabet) for i in range(32 + x))
    # return token

    token = secrets.token_hex(17)  # token-ul va avea lungime 34
    return token


def comp_secv_d(secv1, secv2):
    # a1 = 0
    # a2 = 0
    # # daca au lungimi diferite, e imposibil sa fie egale
    # if len(secv1) != len(secv2):
    #     return False
    # for i in range(len(secv2)):
    #     # si ramura if si ramura else se executa in aproximativ acelasi timp,
    #     # deci metoda de comparare este safe impotriva unui timing attack
    #     if secv1[i] != secv2[i]:
    #         a1 += 1
    #     else:
    #         a2 += 1
    # if a1 == 0:
    #     return True
    # else:
    #     return False
    return secrets.compare_digest(secv1, secv2)


def key_e():
    key = secrets.token_hex(50)  # cheia va avea lungime 100
    return key


def store_password_f(password):
    salt = secrets.token_bytes(32)
    key = hashlib.pbkdf2_hmac('sha256', password.encode('utf-8'), salt, 100000)
    storage = salt + key
    return storage


if __name__ == "__main__":
    # a)
    password = parola_a()
    print("\na) Parola:")
    print(password)

    # b)
    url = url_safe_b()
    print("\nb) String URL-safe:")
    print(url)
    print("Lungime URL: " + str(len(url)))

    # c)
    token = hex_token_c()
    print("\nc) Token hexazecimal:")
    print(token)
    print("Lungime Token: " + str(len(token)))

    # d)
    secv1 = "secventa1"
    secv2 = "secventa2"
    print("\nd) Comparare '" + secv1 + "' cu '" + secv2 + "':")
    if comp_secv_d(secv1, secv2):
        print("Sunt egale")
    else:
        print("Sunt diferite")

    print("Comparare '" + secv1 + "' cu '" + secv1 + "':")
    if comp_secv_d(secv1, secv1):
        print("Sunt egale")
    else:
        print("Sunt diferite")

    # e)
    key = key_e()
    print("\ne) Cheie:")
    print(key)
    print("Lungime Cheie: " + str(len(key)))

    # f)
    print("\nf) Stocare parola:")
    storage = store_password_f("password0")
    salt = storage[:32]
    key = storage[32:]
    new_key = hashlib.pbkdf2_hmac('sha256', "password0".encode('utf-8'), salt, 100000)

    if new_key == key:
        print("Password is correct")
    else:
        print("Password is incorrect")
