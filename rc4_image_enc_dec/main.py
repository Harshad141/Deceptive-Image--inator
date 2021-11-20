import pip
def install(package):
    pip.main(['install', package])
MOD = 256
try:
    import PIL
    from PIL import Image
    import tkinter as tk 
    from tkinter import filedialog
except ModuleNotFoundError:
    install('pillow')
    install('image')

#Defining encryption function
def encryption(plain_text, key):
    
    n = 8
    S = [i for i in range(0, 2**n)]
    key_list = [key[i:i + n] for i in range(0, len(key), n)]
    for i in range(len(key_list)):
	    key_list[i] = int(key_list[i], 2)
    pt = [plain_text[i:i + n] for i in range(0, len(plain_text), n)]
    for i in range(len(pt)):
	    pt[i] = int(pt[i], 2)
    diff = int(len(S)-len(key_list))
    if diff != 0:
	    for i in range(0, diff):
		    key_list.append(key_list[i])

    #First Step of RC4:KSA
    def KSA():
        j = 0
        N = len(S)
        #implementing the algorithm of KSA
        for i in range(0, N):
            j = (j + S[i]+key_list[i]) % N
            S[i], S[j] = S[j], S[i]
        initial_permutation_array = S
    
    KSA()

    #Second step of RC4:PGRA
    def PGRA():
	    N = len(S)
	    i = j = 0
	    global key_stream
	    key_stream = []
        #implementing the algorithm foof PGRA
	    for k in range(0, len(pt)):
		    i = (i + 1) % N
		    j = (j + S[i]) % N
		    S[i], S[j] = S[j], S[i]
		    t = (S[i]+S[j]) % N
		    key_stream.append(S[t])
    PGRA()

    #Defining XOR operation
    def XOR():
	    global cipher_text
	    cipher_text = []
	    for i in range(len(pt)):
		    c = key_stream[i] ^ pt[i]
		    cipher_text.append(c)
    XOR()
    encrypted_to_bits = ""
    for i in cipher_text:
	    encrypted_to_bits += '0'*(n-len(bin(i)[2:]))+bin(i)[2:]
    return encrypted_to_bits #Gives encrypted image as ouitput

#Defining decryption function
def decryption(cipher_text, key):
    n = 7
    S = [i for i in range(0, 2**n)]
    key_list = [key[i:i + n] for i in range(0, len(key), n)]
    for i in range(len(key_list)):
	    key_list[i] = int(key_list[i], 2)
    global pt
    pt = [cipher_text[i:i + n] for i in range(0, len(cipher_text), n)]
    for i in range(len(pt)):
	    pt[i] = int(pt[i], 2)
    diff = int(len(S)-len(key_list))
    if diff != 0:
	    for i in range(0, diff):
		    key_list.append(key_list[i])

    #First Step of RC4:KSA
    def KSA():
	    j = 0
	    N = len(S)
	    for i in range(0, N):
		    j = (j + S[i]+key_list[i]) % N
		    S[i], S[j] = S[j], S[i]
	    initial_permutation_array = S
    KSA()

    #Second step of RC4:PGRA
    def do_PGRA():
	    N = len(S)
	    i = j = 0
	    global key_stream
	    key_stream = []
	    for k in range(0, len(pt)):
		    i = (i + 1) % N
		    j = (j + S[i]) % N
		    S[i], S[j] = S[j], S[i]
		    t = (S[i]+S[j]) % N
		    key_stream.append(S[t])
    do_PGRA()
    cipher_text = [int(cipher_text[i:i + n],2) for i in range(0, len(cipher_text), n)]

    #Defining nad implementing XOR operation
    def do_XOR():
	    global original_text
	    original_text = []
	    for i in range(len(cipher_text)):
		    p = key_stream[i] ^ cipher_text[i]
		    original_text.append(p)
    do_XOR()
    decrypted_to_bits = ""
    for i in original_text:
	    decrypted_to_bits += '0'*(n-len(bin(i)[2:]))+bin(i)[2:]
    return decrypted_to_bits #Gives decrypted image as ouitput

#
def image_decoder(img_og):
    rgb_matrix = img_og.getdata()
    rgb_as_bin = ''
    for pix in rgb_matrix:
        for col in pix:
            rgb_as_bin+=bin(col)[2:].zfill(8)
    return rgb_as_bin

#
def image_encoder(rgb_as_bin,width,height,mode):
    rgb_list = []
    for i in range(0,len(rgb_as_bin),8):
        rgb_list.append(int(rgb_as_bin[i:i+8],2))
    byte_form = bytes(rgb_list)
    cons_img = Image.frombytes('RGB', (width,height), byte_form)
    if mode == 1:#encryption mode
        cons_img.save('enc_img.png')
    else:
        cons_img.save('dec_img.png')
        
#Defining main function that saves images after encryption/decryption
def main():
    print("Please upload the image...")
    root = tk.Tk()
    root.withdraw()
    file_path = filedialog.askopenfilename()
    choice = int(input("1. Encrypt\n2. Decrypt\n"))
    if choice == 1:
        img_og = Image.open(file_path)
        width, height = img_og.size
        rgb_as_bin = image_decoder(img_og)
        key = input("Enter key: ")
        cipher_text = encryption(rgb_as_bin,key)
        image_encoder(cipher_text,width,height,1)
        print("Encrypted image saved as enc_img.png")
    elif choice == 2:
        img_og = Image.open(file_path)
        width, height = img_og.size
        rgb_as_bin = image_decoder(img_og)
        key = input("Enter key: ")
        og_text = encryption(rgb_as_bin,key)
        image_encoder(og_text,width,height,0)
        print("Encrypted image saved as dec_img.png")
main()
