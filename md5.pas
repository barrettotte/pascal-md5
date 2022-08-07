program MD5;

type
    DigestBuffer = array[0..4] of longword; // A,B,C,D
    TestCase = record
        Msg, Hash: string;
    end;

const
    InitA: longword = $67452301;
    InitB: longword = $efcdaB89;
    InitC: longword = $98badcfe;
    InitD: longword = $10325476;

    Shifts: array[0..15] of integer = (
        7, 12, 17, 22, 5, 9, 14, 20, 
        4, 11, 16, 23, 6, 10, 15, 21
    );

    T: array[0..63] of longword = (
        $d76aa478, $e8c7b756, $242070db, $c1bdceee,
        $f57c0faf, $4787c62a, $a8304613, $fd469501,
        $698098d8, $8b44f7af, $ffff5bb1, $895cd7be,
        $6b901122, $fd987193, $a679438e, $49b40821,
        $f61e2562, $c040b340, $265e5a51, $e9b6c7aa,
        $d62f105d, $02441453, $d8a1e681, $e7d3fbc8,
        $21e1cde6, $c33707d6, $f4d50d87, $455a14ed,
        $a9e3e905, $fcefa3f8, $676f02d9, $8d2a4c8a,
        $fffa3942, $8771f681, $6d9d6122, $fde5380c,
        $a4beea44, $4bdecfa9, $f6bb4b60, $bebfbc70,
        $289b7ec6, $eaa127fa, $d4ef3085, $04881d05,
        $d9d4d039, $e6db99e5, $1fa27cf8, $c4ac5665,
        $f4292244, $432aff97, $ab9423a7, $fc93a039,
        $655b59c3, $8f0ccc92, $ffeff47d, $85845dd1,
        $6fa87e4f, $fe2ce6e0, $a3014314, $4e0811a1,
        $f7537e82, $bd3af235, $2ad7d2bb, $eb86d391
    );

    TestCases: array[0..6] of TestCase = (
        (Msg: ''; Hash: '0xd41d8cd98f00b204e9800998ecf8427e'),
        (Msg: 'a'; Hash: '0x0cc175b9c0f1b6a831c399e269772661'),
        (Msg: 'abc'; Hash: '0x900150983cd24fb0d6963f7d28e17f72'),
        (Msg: 'message digest'; Hash: '0xf96b697d7cb7938d525a2f31aaf161d0'),
        (Msg: 'abcdefghijklmnopqrstuvwxyz'; Hash: '0xc3fcd3d76192e4007dfb496cca67e13b'),
        (Msg: 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789'; Hash: '0xd174ab98d277d9f5a5611c2c9f419d9f'),
        (Msg: '12345678901234567890123456789012345678901234567890123456789012345678901234567890'; Hash: '0x57edf4a22be3c955ac49da2e2107b67a')
    );

(* Initialize T. T[i] = 2^32 * abs(sin(i+1)) *)
procedure InitT;
var 
    i: Integer;
begin
    for i := 0 to 63 do
    begin
        T[i] := trunc((1 << 32) * abs(sin(i + 1)));
        (* writeln (T[i]); *)
    end;
    (* NOTE: Decided to go with compile time array, but this still works *)
end;

(* Auxiliary function 1. F(X,Y,Z) = XY OR NOT(X) Z *)
function AuxF(x, y, z: longword): longword;
begin
    AuxF := (x and y) or ((not x) and z);
end;

(* Auxiliary function 2. G(X,Y,Z) = XZ OR Y NOT(Z) *)
function AuxG(x, y, z: longword): longword;
begin
    AuxG := (x and z) or (y and (not z));
end;

(* Auxiliary function 3. H(X,Y,Z) = X XOR Y XOR Z *)
function AuxH(x, y, z: longword): longword;
begin
    AuxH := x xor y xor z;
end;

(* Auxiliary function 4. I(X,Y,Z) = Y XOR (X OR NOT(Z)) *)
function AuxI(x, y, z: longword): longword;
begin
    AuxI := y xor (x or (not z));
end;

(* Rotate x left by n-bits (modulo 32) *)
function RotateLeft32(x, n: longword): longword;
begin
    RotateLeft32 := (x << n) or (x >> (32 - n));
end;

(* Compute MD5 hash of given string *)
function ComputeMD5(msg: string): string;
var
    i, j: integer;
    msgLenBytes, msgLenBits, paddedLen, blockCount, totalLen: longword;
    a, b, c, d, tmpA, tmpB, tmpC, tmpD: longword;
    padded: packed array of byte;
    block: packed array[0..15] of integer;
begin
    (* calculate padding *)
    msgLenBytes := Length(msg);
    msgLenBits := msgLenBytes << 3;
    blockCount := ((msgLenBytes + 8) >> 6) + 1;
    totalLen := blockCount << 6;
    paddedLen := totalLen - msgLenBytes;

    (* pad message *)
    setLength(padded, paddedLen);
    padded[0] := $80; // append bit (0b1000000)
    for i := 0 to 8 do
    begin
        padded[paddedLen - 8 + i] := msgLenBits;
        msgLenBits := msgLenBits >> 8;
    end;

    (* process each block *)
    a := InitA;
    b := InitB;
    c := InitC;
    d := InitD;
    
    
end;

begin
    ComputeMD5(TestCases[2].Msg);
end.
