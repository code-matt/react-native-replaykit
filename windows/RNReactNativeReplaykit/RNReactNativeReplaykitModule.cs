using ReactNative.Bridge;
using System;
using System.Collections.Generic;
using Windows.ApplicationModel.Core;
using Windows.UI.Core;

namespace React.Native.Replaykit.RNReactNativeReplaykit
{
    /// <summary>
    /// A module that allows JS to share data.
    /// </summary>
    class RNReactNativeReplaykitModule : NativeModuleBase
    {
        /// <summary>
        /// Instantiates the <see cref="RNReactNativeReplaykitModule"/>.
        /// </summary>
        internal RNReactNativeReplaykitModule()
        {

        }

        /// <summary>
        /// The name of the native module.
        /// </summary>
        public override string Name
        {
            get
            {
                return "RNReactNativeReplaykit";
            }
        }
    }
}
