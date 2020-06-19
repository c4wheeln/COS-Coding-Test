Class INFORMATION.PalindromeProduction Extends Ens.Production
{

XData ProductionDefinition
{
<Production Name="INFORMATION.PalindromeProduction" TestingEnabled="true" LogGeneralTraceEvents="true">
  <Description>Palindrome Production</Description>
  <ActorPoolSize>2</ActorPoolSize>
  <Item Name="PalindromeService" Category="" ClassName="INFORMATION.PalindromeService" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="ArchivePath">C:\InterSystems\IRIS1\mgr\Temp\Archive\</Setting>
    <Setting Target="Adapter" Name="FilePath">C:\InterSystems\IRIS1\mgr\Temp\</Setting>
    <Setting Target="Adapter" Name="WorkPath">C:\InterSystems\IRIS1\mgr\Temp\Work\</Setting>
    <Setting Target="Host" Name="TargetConfigNames">PalindromeProcess</Setting>
  </Item>
  <Item Name="PalindromeProcess" Category="" ClassName="INFORMATION.PalindromeProcess" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="PalindromeOperation" Category="" ClassName="INFORMATION.PalindromeOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="FilePath">C:\InterSystems\IRIS1\mgr\Temp\Output\</Setting>
  </Item>
</Production>
}

}

