import ReactPageScroller from 'react-page-scroller';
import classes from "./Home.module.css"
import SecondPage from "./SecondPage/SecondPage";
import ThirdPage from "./ThirdPage/ThirdPage";
import Connection from "../Login/Connection";

function Home(){

    let currentPage = 0;

    function handlePageChange(number) {
      currentPage = number
  
    };

    return(
        <ReactPageScroller
        pageOnChange={handlePageChange}
        customPageNumber={currentPage}>
            
            <p>intro</p>
            <h2 className={classes.firstPage}>
                <div className={classes.titleUSC}>
                    <h1><span>USC</span>   <span>USC</span></h1>
                </div>
            </h2>
            <div className={classes.secondPage}>
                <SecondPage/>
            </div>
                
                
            <div className={classes.thirdPage}>
                <h2>La collection NFT</h2>
                <ThirdPage />
            </div>
        </ReactPageScroller>
    )
}

export default Home;
