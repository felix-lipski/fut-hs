import Data.Int
import Foreign.Ptr
import Foreign.Marshal.Alloc
import Foreign.Marshal.Array
import Foreign.Storable

-- Futhark Context FFI
data Futhark_Context_Config
foreign import ccall "futhark_context_config_new"
  futhark_context_config_new :: IO (Ptr Futhark_Context_Config)
data Futhark_Context
foreign import ccall "futhark_context_new"
  futhark_context_new :: Ptr Futhark_Context_Config -> IO (Ptr Futhark_Context)

foreign import ccall "futhark_context_config_free"
  futhark_context_config_free :: Ptr Futhark_Context_Config -> IO ()
foreign import ccall "futhark_context_free"
  futhark_context_free :: Ptr Futhark_Context -> IO ()
futhark_free_full_context :: Ptr Futhark_Context -> Ptr Futhark_Context_Config -> IO ([()])
futhark_free_full_context ctx cfg = sequence [ futhark_context_free ctx, futhark_context_config_free cfg ]

-- Futhark Data FFI
data Futhark_i32_1d
foreign import ccall "futhark_new_i32_1d"
  futhark_new_i32_1d :: Ptr Futhark_Context -> Ptr Int32
                     -> Int32 -> IO (Ptr Futhark_i32_1d)
foreign import ccall "futhark_free_i32_1d"
  futhark_free_i32_1d :: Ptr Futhark_Context -> Ptr Futhark_i32_1d -> IO (Ptr Int32)

foreign import ccall "futhark_entry_dotprod"
  futhark_entry_dotprod :: Ptr Futhark_Context -> Ptr Int32
                        -> Ptr Futhark_i32_1d -> Ptr Futhark_i32_1d 
                        -> Ptr Int32 -> IO ()

foreign import ccall "futhark_entry_times_two"
  futhark_entry_times_two :: Ptr Futhark_Context -> Ptr Int32 -> Ptr Int32 -> IO ()

foreign import ccall "entry_id_c"
  entry_id_c :: Ptr Int32 -> Ptr Int32 -> IO ()

foreign import ccall "entry_times_two_c"
  entry_times_two_c :: Ptr Int32 -> Ptr Int32 -> IO ()

main :: IO ()
main = do
    zPrt <- malloc :: IO (Ptr Int32)
    poke zPrt (2::Int32)

    cfg <- futhark_context_config_new
    ctx <- futhark_context_new cfg
    
    x <- newArray [1,2,3]
    y <- newArray [1,5,7]
    
    x_arr <- futhark_new_i32_1d ctx x 4
    y_arr <- futhark_new_i32_1d ctx y 4
    
    dotProdRes <- alloca $ \res -> futhark_entry_dotprod ctx res x_arr y_arr zPrt >> peek res


    -- res2 <- alloca $ \p -> futhark_entry_times_two ctx p zPrt >> peek p

    -- z1 <- peek zPrt

    -- futhark_entry_times_two ctx zPrt zPrt

    -- z2 <- peek zPrt

    res <- alloca $ \res -> futhark_entry_times_two ctx res zPrt >> peek res
    
    -- res <- alloca $ \res -> entry_times_two_c res zPrt >> peek res

    sequence [ futhark_free_i32_1d ctx x_arr, futhark_free_i32_1d ctx y_arr ]
    futhark_free_full_context ctx cfg

    -- putStrLn $ "z: " ++ show z1 
    -- putStrLn $ "z: " ++ show z2
    -- putStrLn $ "res2: " ++ show res2
    -- putStrLn $ "res: " ++ show res
    putStrLn $ "Dot prod: " ++ show dotProdRes
