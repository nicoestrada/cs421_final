import Network.Socket
import qualified Data.ByteString.Char8 as BS
import Network.Socket.ByteString (sendAll, recv)

main :: IO ()
main = do
    -- Create a socket
    sock <- socket AF_INET Stream defaultProtocol
    
    -- Connect to the server
    connect sock (SockAddrInet 8080 (tupleToHostAddress (127, 0, 0, 1)))
    
    -- Send a message
    sendAll sock $ BS.pack "GET / HTTP/1.1\r\nHost: localhost\r\n\r\n"
    
    -- Receive the response
    response <- recv sock 1024
    
    -- Print the response
    putStrLn $ "Received: " ++ BS.unpack response
    
    -- Close the connection
    close sock

    -- Basic test file generated with help of AI
