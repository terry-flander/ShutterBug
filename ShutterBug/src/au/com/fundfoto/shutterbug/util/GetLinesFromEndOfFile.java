package au.com.fundfoto.shutterbug.util;

import java.io.*;
import java.util.*;

public class GetLinesFromEndOfFile
{
    static public class BackwardsFileInputStream extends InputStream
    {
        public BackwardsFileInputStream(File file) throws IOException
        {
            assert (file != null) && file.exists() && file.isFile() && file.canRead();

            raf = new RandomAccessFile(file, "r");
            currentPositionInFile = raf.length();
            currentPositionInBuffer = 0;
        }

        public int read() throws IOException
        {
            if (currentPositionInFile <= 0)
                return -1;
            if (--currentPositionInBuffer < 0)
            {
                currentPositionInBuffer = buffer.length;
                long startOfBlock = currentPositionInFile - buffer.length;
                if (startOfBlock < 0)
                {
                    currentPositionInBuffer = buffer.length + (int)startOfBlock;
                    startOfBlock = 0;
                }
                raf.seek(startOfBlock);
                raf.readFully(buffer, 0, currentPositionInBuffer);
                return read();
            }
            currentPositionInFile--;
            return buffer[currentPositionInBuffer];
        }

        public void close() throws IOException
        {
            raf.close();
        }

        private final byte[] buffer = new byte[4096];
        private final RandomAccessFile raf;
        private long currentPositionInFile;
        private int currentPositionInBuffer;
    }

    public static List<String> head(File file, int numberOfLinesToRead) throws IOException
    {
        return head(file, "ISO-8859-1" , numberOfLinesToRead);
    }

    public static List<String> head(File file, String encoding, int numberOfLinesToRead) throws IOException
    {
        assert (file != null) && file.exists() && file.isFile() && file.canRead();
        assert numberOfLinesToRead > 0;
        assert encoding != null;

        LinkedList<String> lines = new LinkedList<String>();
        BufferedReader reader= new BufferedReader(new InputStreamReader(new FileInputStream(file), encoding));
        for (String line = null; (numberOfLinesToRead-- > 0) && (line = reader.readLine()) != null;)
        {
            lines.addLast(line);
        }
        reader.close();
        return lines;
    }

    public static List<String> tail(File file, int numberOfLinesToRead) throws IOException
    {
        return tail(file, "ISO-8859-1" , numberOfLinesToRead);
    }

    public static List<String> tail(File file, String encoding, int numberOfLinesToRead) throws IOException
    {
        assert (file != null) && file.exists() && file.isFile() && file.canRead();
        assert numberOfLinesToRead > 0;
        assert (encoding != null) && encoding.matches("(?i)(iso-8859|ascii|us-ascii).*");

        LinkedList<String> lines = new LinkedList<String>();
        BufferedReader reader= new BufferedReader(new InputStreamReader(new BackwardsFileInputStream(file), encoding));
        for (String line = null; (numberOfLinesToRead-- > 0) && (line = reader.readLine()) != null;)
        {
            // Reverse the order of the characters in the string
            char[] chars = line.toCharArray();
            for (int j = 0, k = chars.length - 1; j < k ; j++, k--)
            {
                char temp = chars[j];
                chars[j] = chars[k];
                chars[k]= temp;
            }
            lines.addFirst(new String(chars));
        }
        reader.close();
        return lines;
    }
    
    public static void main(String[] args)
    {
        try
        {
            File file = new File("/usr/share/dict/words");
            int n = 10;

            {
                System.out.println("Head of " + file);
                int index = 0;
                for (String line : head(file, n))
                {
                    System.out.println(++index + "\t[" + line + "]");
                }
            }
            {
                System.out.println("Tail of " + file);
                int index = 0;
                for (String line : tail(file, "us-ascii", n))
                {
                    System.out.println(++index + "\t[" + line + "]");
                }
            }
        }
        catch (Exception e)
        {
            e.printStackTrace();
        }
    }
}