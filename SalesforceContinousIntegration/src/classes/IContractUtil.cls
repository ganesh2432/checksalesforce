public with sharing class  IContractUtil {
	public IContractUtil(){

	}
	public static void getEncryptionUtil(){
	String keyString='TestData';
	Blob keyStringBlob=Blob.valueOf(keyString);
	Blob shaBlob=Crypto.generateDigest('SHA1', keyStringBlob);
	String shaBlobString=EncodingUtil.base64Encode(shaBlob);
	Integer[] arrayOfBytes=B64ToBytes(shaBlobString);
	System.debug(arrayOfBytes);
    System.debug(shaBlobString.getChars());
	}

	public static List<Integer> B64ToBytes (String sIn) {
        Map<Integer,Integer> base64 = new Map<Integer,Integer>{65=>0,66=>1,67=>2,68=>3,69=>4,70=>5,71=>6,72=>7,73=>8,74=>9,75=>10,76=>11,77=>12,78=>13,79=>14,80=>15,81=>16,82=>17,83=>18,84=>19,85=>20,86=>21,87=>22,88=>23,89=>24,90=>25,97=>26,98=>27,99=>28,100=>29,101=>30,102=>31,103=>32,104=>33,105=>34,106=>35,107=>36,108=>37,109=>38,110=>39,111=>40,112=>41,113=>42,114=>43,115=>44,116=>45,117=>46,118=>47,119=>48,120=>49,121=>50,122=>51,48=>52,49=>53,50=>54,51=>55,52=>56,53=>57,54=>58,55=>59,56=>60,57=>61,43=>62,47=>63};
        List<Integer> lstOut = new List<Integer>();

        if ( sIn == null || sIn == '' ) return lstOut;
        sIn += '='.repeat( 4 - Math.mod( sIn.length(), 4) );
         for ( Integer idx=0; idx < sIn.length(); idx += 4 ) {
            if ( base64.get(sIn.charAt(idx+1)) != null ) lstOut.add( (base64.get(sIn.charAt(idx)) << 2) | (base64.get(sIn.charAt(idx+1)) >>> 4) );
            if ( base64.get(sIn.charAt(idx+2)) != null ) lstOut.add( ((base64.get(sIn.charAt(idx+1)) & 15)<<4) | (base64.get(sIn.charAt(idx+2)) >>> 2) );
            if ( base64.get(sIn.charAt(idx+3)) != null ) lstOut.add( ((base64.get(sIn.charAt(idx+2)) & 3)<<6) | base64.get(sIn.charAt(idx+3)) );
        }
         System.Debug('B64ToBytes: [' + sIn + '] = ' + lstOut);
        return lstOut;
    }

}