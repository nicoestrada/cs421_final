import Control.Concurrent (forkIO)
import Network.Socket
import Network.Socket.ByteString (recv, sendAll)
import qualified Data.ByteString.Char8 as BS

main :: IO ()
main = do
    sock <- socket AF_INET Stream 0 -- init socket
    bind sock (SockAddrInet 8080 0) -- bind it to port 8080
    listen sock 5
    putStrLn "Server listening on port 8080"
    mainLoop sock -- start mainloop with socket

mainLoop :: Socket -> IO ()
mainLoop sock = do
    (conn, addr) <- accept sock
    putStrLn $ "New connection from " ++ show addr -- prints addr of connection
    forkIO $ handleClient conn --uses client handler with established connection
    mainLoop sock -- keeps the listener on by calling itself

handleClient :: Socket -> IO ()
handleClient conn = do
    msg <- recv conn 1024
    putStrLn $ "Received: " ++ BS.unpack msg
    let response = "HTTP/1.1 200 OK\r\nContent-Type: text/plain\r\n\r\nHello, World!" -- response from server to client with info 
    sendAll conn $ BS.pack response
    close conn -- close connection after client handler is done
