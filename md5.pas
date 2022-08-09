program MD5;

uses sysutils; (* IntToHex *)

type
    TestCase = record
        Msg, Hash: string;
    end;

const
    (* initial values of registers *)
    InitA: longword = $67452301;
    InitB: longword = $efcdab89;
    InitC: longword = $98badcfe;
    InitD: longword = $10325476;

    (* per-round shift amounts *)
    Shifts: array of longword = (7, 12, 17, 22, 5, 9, 14, 20, 4, 11, 16, 23, 6, 10, 15, 21);

    (* Binary integer parts of sines of integers (in radians) *)
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

    (* test cases from RFC-1321 *)
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
    i: integer;
begin
    for i := 0 to 63 do
    begin
        T[i] := Trunc((uint64(1) shl 32) * Abs(Sin(i + 1.0)));
    end;
    (* NOTE: Decided to go with compile time array, but this still works if T is redeclared as variable *)
end;

(* Rotate x left by n-bits *)
function RotateLeft32(x, n: longword): longword;
begin
    RotateLeft32 := (x shl n) or (x shr (32 - n));
end;

(* Compute MD5 hash of given string *)
function ComputeMD5(msg: string): string;
var
    i, j, buffIdx: integer;
    a, b, c, d, a0, b0, c0, d0: longword;
    tmp, round, f, msgBytes, msgBits, blocks, padLen: longword;
    padded: packed array of byte;
    buffer: packed array[0..15] of longword;
    hash: packed array[0..15] of byte;
    hashStr: string;
begin
    (* calculate padding *)
    msgBytes := Length(msg);
    msgBits := msgBytes * 8;
    blocks := ((msgBytes + 8) shr 6) + 1;
    padLen := (blocks shl 6) - msgBytes;
    SetLength(padded, padLen);

    (* pad message *)
    padded[0] := $80;
    for i := 0 to 7 do
    begin
        padded[padLen - 8 + i] := msgBits;
        msgBits := msgBits shr 8;
    end;
    
    (* init registers *)
    a := InitA;
    b := InitB;
    c := InitC;
    d := InitD;

    (* warning about unintialized buffer ? *)
    for i := 0 to 15 do
        buffer[i] := 0;

    (* Process MD5 hash one message block at a time *)
    for i := 0 to (blocks-1) do
    begin
        (* load buffer with padded message *)
        tmp := i shl 6;
        for j := 0 to 63 do
        begin
            buffIdx := j shr 2;

            if tmp < msgBytes then
                buffer[buffIdx] := (Ord(msg[tmp + 1]) shl 24) or (buffer[buffIdx] shr 8)
            else
                buffer[buffIdx] := (padded[tmp - msgBytes] shl 24) or (buffer[buffIdx] shr 8);
            tmp := tmp + 1;
        end;

        (* init registers *)
        a0 := a;
        b0 := b;
        c0 := c;
        d0 := d;

        (* apply transformations *)
        for j := 0 to 63 do
        begin
            round := j shr 4;
            buffIdx := j;
            f := 0;

            case round of
                0:  (* Auxiliary function F *)
                    begin
                        f := (b and c) or ((not b) and d);
                        buffIdx := j;
                    end;
                1:  (* Auxiliary function G *)
                    begin
                        f := (b and d) or (c and (not d));
                        buffIdx := ((j * 5) + 1) and $0F;
                    end;
                2:  (* Auxiliary function H *)
                    begin
                        f := b xor c xor d;
                        buffIdx := ((j * 3) + 5) and $0F;
                    end;
                3:  (* Auxiliary function I *)
                    begin
                        f := c xor (b or (not d));
                        buffIdx := (j * 7) and $0F;
                    end;
            end;

            tmp := b + RotateLeft32(a + f + buffer[buffIdx] + T[j], Shifts[(round * 4) or (j and 3)]);
            a := d;
            d := c;
            c := b;
            b := tmp;
        end;

        a := a + a0;
        b := b + b0;
        c := c + c0;
        d := d + d0;
    end;

    (* finalize hash *)
    buffIdx := 0;
    tmp := 0;
    for i := 0 to 3 do
    begin
        case i of 
            0: tmp := a;
            1: tmp := b;
            2: tmp := c;
            3: tmp := d;
        end;
        for j := 0 to 3 do
        begin
            hash[buffIdx] := tmp;
            buffIdx := buffIdx + 1;
            tmp := tmp >> 8;
        end;
    end;

    (* return hash as string *)
    hashStr := '0x';
    for i := 0 to 15 do
    begin
        hashStr := hashStr + Lowercase(IntToHex(hash[i], 2));
    end;

    ComputeMD5 := hashStr;
end;

(* main *)
var
    i: integer;
    actual: string;
begin

    Writeln('msg: "' + TestCases[2].Msg + '"');
    Writeln('expected: ' + TestCases[2].Hash);
    ComputeMD5(TestCases[2].Msg);
    Writeln('');

    for i := 0 to (Length(TestCases) - 1) do
    begin
        Writeln('"' + TestCases[i].Msg + '"');
        actual := ComputeMD5(TestCases[i].Msg);
        assert(CompareStr(actual, TestCases[i].Hash) = 0, 'Calculated hash does not match test case');
        Writeln('  actual:   ' + actual);
        Writeln('  expected: ' + TestCases[i].Hash);
        Writeln('');
    end;
end.
