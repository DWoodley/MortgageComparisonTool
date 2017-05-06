library(shiny)

# Define server logic required to draw Mortgage cash flows
shinyServer(function(input, output) {
  
    output$MortgagePlot <- renderPlot({
    
    face <- input$face*1000
    mort1 <- PayDownSched(face,input$rate1/1200,input$term1)
    mort2 <- PayDownSched(face,input$rate2/1200,input$term2)
    len <- max(length(mort1$Balance),length(mort2$Balance))

    par(mfrow=c(2,2))
    plot(mort1$Balance,typ="l",
         col="green",
         xlab="Months",
         ylab="Balance ($)",
         main= paste("Remaining Balance Over Time\n($",format(face,scientific=FALSE),"Initial Balance)"),
         xlim = c(0,len))
    
    lines(mort2$Balance,typ="l",
          col="red",
          xlab="Months",
          ylab="Balance ($)")
    

    barplot(c(sum(mort1$Interest),sum(mort2$Interest)),
            col = c("green","red"),
            main = "Sum of Interest Payments Over Term ($)",
            legend.text = TRUE,
            names.arg = c(paste("Mortgage 1\n$",sum(mort1$Interest)),
                          paste("Mortgage 2\n$",sum(mort2$Interest))),
            ylim = c(0,max(sum(mort1$Interest),sum(mort2$Interest))+1000))
    
    barplot(c(mort1$MinPayment[1],mort2$MinPayment[1]),
            col = c("green","red"),
            main = "Monthly Payment ($)",
            legend.text = TRUE,
            names.arg = c(paste("Mortgage 1\n$",mort1$MinPayment[1]),
                          paste("Mortgage 2\n$",mort2$MinPayment[1])),
            ylim = c(0,max(mort1$MinPayment[1],mort2$MinPayment[1])+100))
    
  })
  
})

PrRt <- function(r,N) {
    z <- (1/r)*(1 - (1/((1+r)^N)))
    return (z)
}

CF <- function(PV,r,N) {
    z <- PrRt(r,N) 
    cf <- PV/z
    return (cf)
}

PayDownSched <- function(Prin,r,N,Pmt=0) {
    Period <- 1:N
    MinPmt <- round(CF(Prin,r,N),2)
    Pmts <- rep(max(MinPmt,Pmt),N)
    Bal <- rep(Prin,N)
    Int <- rep(0,N)
    Prn <- rep(0,N)
    
    
    #Schedule <- data.frame(Period = Period)
    #Schedule <- cbind(Schedule,data.frame(Payment = Pmts))
    
    Schedule <- data.frame(Payment = Pmts)
    Schedule <- cbind(Schedule,data.frame(MinPayment = MinPmt))
    Schedule <- cbind(Schedule,data.frame(Balance = Bal))
    Schedule <- cbind(Schedule,data.frame(Interest = Int))
    Schedule <- cbind(Schedule,data.frame(Principal = Prn))
    
    #### Show Added Principal
    for (i in 1:N) {
        Schedule$Interest[i] <- round(Schedule$Balance[i]*r,2)
        Schedule$Principal[i] <- min(max(Schedule$Payment[i] - Schedule$Interest[i],0),Schedule$Balance)
        
        if (i < N) {
            Schedule$Balance[i+1] <- max(Schedule$Balance[i] - Schedule$Principal[i],0)
            
            if(Schedule$Balance[i+1]==0) {
                Schedule$Balance[(i+1):N] = 0
                Schedule$Interest[(i+1):N] = 0
                Schedule$Principal[(i+1):N] = 0
                Schedule$Payment[(i+1):N] = 0
                Schedule$MinPayment[(i+1):N] = 0
                
                Schedule <- Schedule[-((i+1):N),]
                
                break
            }
        }
    }
    
    return(Schedule)
}
